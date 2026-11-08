% 4 tiles MMMM
tile(1..4, m, m, m, m).
img(m,m,m,m, "https://thumb.wikimedia.org/wikipedia/commons/thumb/a/a0/Carcassonne_0r0c_R0%2BM.svg/1280px-Carcassonne_0r0c_R0%2BM.svg.png?utm_source=en.wikipedia.org&utm_campaign=imageinfo&utm_content=thumbnail").

% 2 tiles RMMM
tile(5..6, r, m, m, m).
img(r,m,m,m,"https://thumb.wikimedia.org/wikipedia/commons/thumb/d/dd/Carcassonne_1r0c_R0%2BM.svg/60px-Carcassonne_1r0c_R0%2BM.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").


% 8 tiles MRMR
tile(7..14, m, r, m, r).
img(m,r,m,r,"https://thumb.wikimedia.org/wikipedia/commons/thumb/3/39/Carcassonne_2r0c_R0_%28A%29.svg/60px-Carcassonne_2r0c_R0_%28A%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 9 tiles RRMM
tile(15..23, r, r, m, m).
img(r,r,m,m,"https://thumb.wikimedia.org/wikipedia/commons/thumb/d/d4/Carcassonne_2r0c_R0_%28B%29.svg/60px-Carcassonne_2r0c_R0_%28B%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 4 tiles RRMR
tile(24..27, r, r, m, r).
img(r,r,m,r,"https://thumb.wikimedia.org/wikipedia/commons/thumb/2/2f/Carcassonne_3r0c_R0%2BV.svg/60px-Carcassonne_3r0c_R0%2BV.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 1 tile RRRR
tile(28, r, r, r, r).
img(r,r,r,r,"https://thumb.wikimedia.org/wikipedia/commons/thumb/9/94/Carcassonne_4r0c_R0%2BV.svg/60px-Carcassonne_4r0c_R0%2BV.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 5 tiles MMCM
tile(29..33, m, m, c, m).
img(m,m,c,m,"https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b7/Carcassonne_0r1c_R0.svg/60px-Carcassonne_0r1c_R0.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 4 tiles MRCR
tile(34..37, m, r, c, r).
img(m,r,c,r,"https://thumb.wikimedia.org/wikipedia/commons/thumb/1/10/Carcassonne_2r1c_R0_%28A%29.svg/60px-Carcassonne_2r1c_R0_%28A%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 3 tiles RRCM
tile(38..40, r, r, c, m).
img(r,r,c,m,"https://thumb.wikimedia.org/wikipedia/commons/thumb/1/1b/Carcassonne_2r1c_R0_%28B%29.svg/60px-Carcassonne_2r1c_R0_%28B%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 3 tiles RMCR
tile(41..43, r, m, c, r).
img(r,m,c,r,"https://thumb.wikimedia.org/wikipedia/commons/thumb/4/47/Carcassonne_2r1c_R0_%28C%29.svg/60px-Carcassonne_2r1c_R0_%28C%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 3 tiles RRCR
tile(44..46, r, r, c, r).
img(r,r,c,r, "https://thumb.wikimedia.org/wikipedia/commons/thumb/4/4f/Carcassonne_3r1c_R0%2BV.svg/60px-Carcassonne_3r1c_R0%2BV.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 3 tiles CMCM
tile(47..49, c, m, c, m).
img(c,m,c,m, "https://thumb.wikimedia.org/wikipedia/commons/thumb/a/a6/Carcassonne_0r2c_R0_%28A%29.svg/60px-Carcassonne_0r2c_R0_%28A%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 2 tiles MMCC
tile(50..51, m, m, c, c).
img(m,m,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/4/4b/Carcassonne_0r2c_R0_%28B%29.svg/60px-Carcassonne_0r2c_R0_%28B%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").

% 1 tile MCMC
tile(52, m, c, m, c).
img(m,c,m,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/c/ce/Carcassonne_0r2c_R0_%28C%29.svg/60px-Carcassonne_0r2c_R0_%28C%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(52, (0, 1, 0, 1)).

% 2 tiles MCMC with shields
tile(53..54, m, c, m, c).
shield(53..54).
img(shield,m,c,m,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/8/8b/Carcassonne_0r2c_R0_%28C%29%2BC.svg/60px-Carcassonne_0r2c_R0_%28C%29%2BC.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(53..54, (0, 1, 0, 1)).

% 3 tiles MMCC
tile(55..57, m, m, c, c).
img(m,m,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/a/ac/Carcassonne_0r2c_R0_%28D%29.svg/60px-Carcassonne_0r2c_R0_%28D%29.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(55..57, (0, 0, 1, 1)).

% 2 tiles MMCC with shields
tile(58..59, m, m, c, c).
shield(58..59).
img(shield,m,m,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/c/c2/Carcassonne_0r2c_R0_%28D%29%2BC.svg/60px-Carcassonne_0r2c_R0_%28D%29%2BC.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(58..59, (0, 0, 1, 1)).

% 3 tiles RRCC
tile(60..62, r, r, c, c).
img(r,r,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/5/5e/Carcassonne_2r2c_R0.svg/60px-Carcassonne_2r2c_R0.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(60..62, (0, 0, 1, 1)).

% 2 tiles RRCC with shields
tile(63..64, r, r, c, c).
shield(63..64).
img(shield,r,r,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/f/f1/Carcassonne_2r2c_R0%2BC.svg/60px-Carcassonne_2r2c_R0%2BC.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(63..64, (0, 0, 1, 1)).

% 3 tiles MCCC
tile(65..67, m, c, c, c).
img(m,c,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/8/87/Carcassonne_0r3c_R0.svg/60px-Carcassonne_0r3c_R0.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(65..67, (0, 1, 1, 1)).

% 1 tile MCCC with shield
tile(68, m, c, c, c).
shield(68).
img(shield,m,c,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b2/Carcassonne_0r3c_R0%2BC.svg/60px-Carcassonne_0r3c_R0%2BC.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(68, (0, 1, 1, 1)).

% 1 tile RCCC
tile(69, r, c, c, c).
img(r,c,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/1/1d/Carcassonne_1r3c_R0.svg/60px-Carcassonne_1r3c_R0.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(69, (0, 1, 1, 1)).

% 2 tiles RCCC with shield
tile(70..71, r, c, c, c).
shield(70..71).
img(shield,r,c,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/6/6a/Carcassonne_1r3c_R0%2BC.svg/60px-Carcassonne_1r3c_R0%2BC.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(70..71, (0, 1, 1, 1)).

% 1 tile CCCC with shield
tile(72, c, c, c, c).
shield(72).
img(shield,c,c,c,c,"https://thumb.wikimedia.org/wikipedia/commons/thumb/8/85/Carcassonne_0r4c_R0%2BC.svg/60px-Carcassonne_0r4c_R0%2BC.svg.png?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail").
tile_conn(72, (1, 1, 1, 1)).
