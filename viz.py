#!/usr/bin/env python3
"""Render a Carcassonne board from rotated/2 atoms.

  python viz.py instance.lp --model model.txt            # model = clingo output text
  python viz.py instance.lp --solve encoding.lp [-c w=20]  # run clingo here
  clingo ... | python viz.py instance.lp --model -         # read from stdin

rotated((D,L,U,R),(Row,Col)): oriented tile (down,left,up,right), 0,0 = top left.
"""

import argparse, hashlib, re, sys, urllib.request
from pathlib import Path
from PIL import Image, ImageDraw

ROTS = (0, 90, 180, 270)


def rot(t, r):  # same convention as the encoding's rt/3
    a, b, c, d = t
    return {0: (a, b, c, d), 90: (d, a, b, c), 180: (c, d, a, b), 270: (b, c, d, a)}[r]


# ------------------------------------------------------------------ input
def parse_instance(path):
    """tiles[id]=(D,L,U,R); url[id]; shield set. img(...) is attached to the tile group
    it follows, so tiles with equal edges but different artwork keep their own image."""
    tiles, url, shield, group = {}, {}, set(), []
    span = lambda a, b: range(int(a), int(b or a) + 1)
    for line in Path(path).read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("%"):
            continue
        if m := re.match(
            r"tile\((\d+)(?:\.\.(\d+))?\s*,\s*(\w+)\s*,\s*(\w+)\s*,\s*(\w+)\s*,\s*(\w+)\)",
            line,
        ):
            group = list(span(m[1], m[2]))
            for t in group:
                tiles[t] = tuple(m[i] for i in range(3, 7))
        elif m := re.match(r"shield\((\d+)(?:\.\.(\d+))?\)", line):
            shield.update(span(m[1], m[2]))
        elif line.startswith("img(") and (m := re.search(r'"([^"]+)"', line)):
            has = line.startswith("img(shield")
            for t in group:
                if (t in shield) == has:
                    url[t] = m[1]
    return tiles, url, shield


ATOM = re.compile(
    r"rotated\(\(\s*(\w+)\s*,\s*(\w+)\s*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*,\s*\(\s*(-?\d+)\s*,\s*(-?\d+)\s*\)\s*\)"
)


def answers(text):
    """Split a solution file into answer sets (each a string containing atoms)."""
    if text.lstrip().startswith("{"):  # clingo --outf=2
        import json

        try:
            data = json.loads(text)
        except json.JSONDecodeError:
            data = None
        if data is not None:
            ws = [w for call in data.get("Call", []) for w in call.get("Witnesses", [])]
            return [" ".join(w.get("Value", [])) for w in ws]
    parts = re.split(r"^Answer:.*$", text, flags=re.M)
    return (
        parts[1:] if len(parts) > 1 else [text]
    )  # no header: whole file is one answer


def parse_model(text, which=-1):
    ans = answers(text)
    if not ans:
        sys.exit("no answer set found in the solution file")
    try:
        block = ans[which - 1 if which > 0 else which]
    except IndexError:
        sys.exit(f"--answer {which}: the file contains only {len(ans)} answer set(s)")
    if len(ans) > 1:
        print(
            f"using answer {which if which > 0 else len(ans)} of {len(ans)}",
            file=sys.stderr,
        )
    cells = {}
    for m in ATOM.finditer(block):
        pos = (int(m[5]), int(m[6]))
        s = tuple(m[i] for i in range(1, 5))
        if cells.get(pos, s) != s:
            sys.exit(f"two different tiles at {pos}")
        cells[pos] = s
    if not cells:
        sys.exit(
            "no rotated((D,L,U,R),(Row,Col)) atoms found in the selected answer set"
        )
    return cells


def solve(instance, enc, consts):
    import clingo

    ctl = clingo.Control(["1"] + [x for c in consts for x in ("-c", c)])
    ctl.load(str(instance))
    ctl.load(str(enc))
    ctl.ground([("base", [])])
    out = []
    if not ctl.solve(
        on_model=lambda m: out.append(" ".join(map(str, m.symbols(shown=True))))
    ).satisfiable:
        sys.exit("UNSAT")
    return out[0]


# ------------------------------------------------------- tile identification
def assign(cells, tiles):
    """rotated/2 only gives the oriented edges, so find which physical tile (id, hence image)
    sits in each cell: bipartite matching cell -> tile id with S in rotations(tile)."""
    cand = {
        p: [t for t in sorted(tiles) if s in {rot(tiles[t], r) for r in ROTS}]
        for p, s in cells.items()
    }
    owner = {}

    def try_(p, seen):
        for t in cand[p]:
            if t in seen:
                continue
            seen.add(t)
            if t not in owner or try_(owner[t], seen):
                owner[t] = p
                return True
        return False

    for p in sorted(cells, key=lambda p: len(cand[p])):
        if not try_(p, set()):
            print(f"warning: no tile available for {cells[p]} at {p}", file=sys.stderr)
    return {p: t for t, p in owner.items()}


def check(cells):
    bad = 0
    for (r, c), s in cells.items():
        if (r, c + 1) in cells and s[3] != cells[(r, c + 1)][1]:
            bad += 1
            print(f"mismatch {(r,c)}|{(r,c+1)}", file=sys.stderr)
        if (r + 1, c) in cells and s[0] != cells[(r + 1, c)][2]:
            bad += 1
            print(f"mismatch {(r,c)}/{(r+1,c)}", file=sys.stderr)
    return bad


# ------------------------------------------------------------------ drawing
FIELD, ROAD, CITY = (126, 172, 84), (240, 232, 205), (160, 108, 60)


def fallback(sides, S):
    im = Image.new("RGB", (S, S), FIELD)
    d = ImageDraw.Draw(im)
    c = S // 2
    D, L, U, R = sides
    if D == "c":
        d.polygon(
            [(0, S), (S, S), (c + S // 4, S - S // 3), (c - S // 4, S - S // 3)],
            fill=CITY,
        )
    if U == "c":
        d.polygon(
            [(0, 0), (S, 0), (c + S // 4, S // 3), (c - S // 4, S // 3)], fill=CITY
        )
    if L == "c":
        d.polygon(
            [(0, 0), (0, S), (S // 3, c + S // 4), (S // 3, c - S // 4)], fill=CITY
        )
    if R == "c":
        d.polygon(
            [(S, 0), (S, S), (S - S // 3, c + S // 4), (S - S // 3, c - S // 4)],
            fill=CITY,
        )
    w = max(3, S // 9)
    for side, end in zip(sides, ((c, S), (0, c), (c, 0), (S, c))):
        if side == "r":
            d.line([(c, c), end], fill=ROAD, width=w)
    if "r" in sides:
        d.ellipse([c - w // 2, c - w // 2, c + w // 2, c + w // 2], fill=ROAD)
    if sides.count("m") == 4 or (sides.count("m") == 3 and "r" in sides):
        d.ellipse([c - S // 6, c - S // 6, c + S // 6, c + S // 6], fill=(200, 80, 80))
    return im


def fetch(url, cache):
    cache.mkdir(exist_ok=True)
    f = cache / (hashlib.md5(url.encode()).hexdigest() + ".png")
    if not f.exists():
        req = urllib.request.Request(url, headers={"User-Agent": "carcassonne-viz/1.0"})
        f.write_bytes(urllib.request.urlopen(req, timeout=15).read())
    return Image.open(f).convert("RGBA")


def render(cells, owner, tiles, url, S, out, ids, cache=Path("imgs")):
    r0 = min(r for r, _ in cells)
    c0 = min(c for _, c in cells)
    H = (max(r for r, _ in cells) - r0 + 1) * S
    W = (max(c for _, c in cells) - c0 + 1) * S
    board = Image.new("RGB", (W, H), (235, 235, 235))
    dr = ImageDraw.Draw(board)
    imgs, failed = {}, 0
    for (r, c), s in cells.items():
        t = owner.get((r, c))
        im = None
        if t is not None and t in url:
            try:
                if url[t] not in imgs:
                    imgs[url[t]] = fetch(url[t], cache)
                angle = next(a for a in ROTS if rot(tiles[t], a) == s)  # clockwise
                base = (
                    imgs[url[t]].resize((S, S), Image.LANCZOS).rotate(-angle)
                )  # PIL turns counter-clockwise
                im = Image.new("RGB", (S, S), FIELD)
                im.paste(base, mask=base)
            except Exception:
                failed += 1
                url.pop(t, None)
        if im is None:
            im = fallback(s, S)
        x, y = (c - c0) * S, (r - r0) * S
        board.paste(im, (x, y))
        dr.rectangle([x, y, x + S - 1, y + S - 1], outline=(60, 60, 60))
        if ids and t is not None:
            dr.text((x + 3, y + 2), str(t), fill=(0, 0, 0))
    board.save(out)
    if failed:
        print(
            f"{failed} images could not be loaded; drew fallback tiles", file=sys.stderr
        )
    print(f"{W//S}x{H//S} board, {len(cells)} tiles -> {out}")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("instance")
    ap.add_argument(
        "solution",
        nargs="?",
        help="file with the solution (clingo output / JSON / atoms), or - for stdin",
    )
    ap.add_argument(
        "--solve",
        metavar="ENC",
        help="run clingo with this encoding instead of reading a file",
    )
    ap.add_argument("--model", help=argparse.SUPPRESS)  # old spelling
    ap.add_argument(
        "--answer",
        type=int,
        default=-1,
        help="which answer set of the file to draw (1-based, default: last)",
    )

    ap.add_argument(
        "-c",
        dest="consts",
        action="append",
        default=[],
        help="clingo constant, e.g. -c w=12",
    )
    ap.add_argument("-o", "--out", default="board.png")
    ap.add_argument("-s", "--size", type=int, default=96)
    ap.add_argument("--ids", action="store_true", help="print tile ids")

    a = ap.parse_args()
    a.solution = a.solution or a.model
    if bool(a.solution) == bool(a.solve):
        ap.error("give exactly one of: a solution file, or --solve ENCODING")

    text = (
        solve(a.instance, a.solve, a.consts)
        if a.solve
        else (sys.stdin.read() if a.solution == "-" else Path(a.solution).read_text())
    )
    cells = parse_model(text, a.answer)
    tiles, url, shield = parse_instance(a.instance)
    if len(cells) != len(tiles):
        print(
            f"warning: {len(cells)} cells but {len(tiles)} tiles in the instance",
            file=sys.stderr,
        )
    if check(cells):
        print("warning: edge mismatches above", file=sys.stderr)
    render(cells, assign(cells, tiles), tiles, url, a.size, a.out, a.ids)
