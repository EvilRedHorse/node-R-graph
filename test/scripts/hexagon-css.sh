#! /bin/bash --posix

# printf "hexagon height calc, enter width: ";
read W;

#Border
B=1

# 2*(width/(2*Math.tan(Math.PI/6)))
H=$(echo "2*($W/(2*s(4*a(1)/6)/c(4*a(1)/6)))" | bc -l);

cat <<EOF
@import url(https://fonts.googleapis.com/css?family=Roboto);

:root {
  --blue: hsla(183, 83%, 83%, 0.9);
  --softyellow: hsla(72, 97%, 94%, 1.00);
  --yellow: hsla(60, 75%, 75%, 1.0);
  --hardyellow: hsla(60, 75%, 50%, 1.0);
}

*, *::before, *::after {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
html {
  font-family: Roboto, Georgia, serif;
}
body {
  color: hsl(0, 0%, 10%);
  background-color: var(--blue);
  padding: 0px;
  border-top: ${B}px solid var(--softyellow);
  margin: 0 auto;
  padding: $(echo "$B*2*(1/(2*s(4*a(1)/6)/c(4*a(1)/6)))" | bc -l)px;
  bottom: 0;
  top: 0;
}
main {
  width: max-content;
  margin: auto;
}
.halfer span {
    position: absolute;
    top: $(echo "($W/4+($B))" | bc -l)px;
    left: 50%;
    transform: translate(-50%, -50%);
}
.less {
  transform: matrix(1, 0, 0, 1, 0, -$H);
}
.zero {
  visibility: hidden;
  display: none;
}
.ibws-fix {
  display: table-row-group;
  font-size: 0;
}
.honeycomb {
  font-size: 100%;
  width: max-content;
  margin: 0px $(echo "($W/4+($B))" | bc -l)px 0px $(echo "($W/4+($B))" | bc -l)px;
  text-align: center;
}
.hexagon {
  position: relative;
  display: inline-block;
  /* left/right margin approx. 25% of .hexagon width + spacing */
  margin: $(echo "$B*2*(1/(2*s(4*a(1)/6)/c(4*a(1)/6)))" | bc -l)px $(echo "($W/4)+($B)" | bc -l)px;
  background-color: var(--softyellow);
  text-align: center;
}
.hexagon, .hexagon::before, .hexagon::after {
  /* easy way: height is width * 1.732
  actual formula is 2*(width/(2*Math.tan(Math.PI/6)))
  remove border-radius for sharp corners on hexagons */
  width: ${W}px;
  height: ${H}px;
  border-radius: 20%/5%;
}
.hexagon::before {
  background-color: inherit;
  content: "";
  position: absolute;
  left: 0;
  transform: rotate(-60deg);
}
.hexagon::after {
  background-color: inherit;
  content: "";
  position: absolute;
  left: 0;
  transform: rotate(60deg);
}
.hexagon:nth-child(odd) {
  /* top approx. 50% of .hexagon height + spacing */
  top: $(echo "($H/2)+($B*3)" | bc -l)px;
}
.hexagon:hover {
  background-color: var(--yellow);
  cursor: pointer;
  z-index: 105;
}
.hexagon:active {
  background-color: var(--hardyellow);
  z-index: 110;
  transform: matrix(0.9, 0, 0.04, 0.9, 0, 0);
}
.hexanone {
  position: relative;
  display: inline-block;
  width: ${W}px;
  height: ${H}px;
  margin: $(echo "2*(1/(2*s(4*a(1)/6)/c(4*a(1)/6)))" | bc -l)px $(echo "($W/4+($B))" | bc -l)px;
}
.hexanone:nth-child(odd) {
  transform: translate(0, 50%);
}
.hexagontent {
  position: absolute;
  top: 45%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 140%;
  font-size: 1.4rem;
  line-height: 1.2;
  z-index: 100;
}
EOF
