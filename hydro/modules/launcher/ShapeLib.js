.pragma library
var N = 120;
var TWO_PI = Math.PI * 2;
function theta(i) { return i * TWO_PI / N - Math.PI / 2; }
function mod(x, m) { return ((x % m) + m) % m; }
function smooth(r, k, p) {
    for (var q = 0; q < p; q++) {
        var o = [];
        for (var i = 0; i < N; i++) {
            var s = 0;
            for (var j = -k; j <= k; j++) s += r[(i + j + N) % N];
            o.push(s / (2 * k + 1));
        }
        r = o;
    }
    return r;
}
function norm(r) {
    var m = 0, i;
    for (i = 0; i < N; i++) m = Math.max(m, r[i]);
    for (i = 0; i < N; i++) r[i] /= m;
    return r;
}
function make(f, k, p) {
    var r = [];
    for (var i = 0; i < N; i++) r.push(f(theta(i)));
    if (k > 0) r = smooth(r, k, p);
    return norm(r);
}
function poly(n) { return function (t) { var a = TWO_PI / n; var ph = mod(t + Math.PI / 2, a); return Math.cos(Math.PI / n) / Math.cos(ph - Math.PI / n); }; }
function waves(n, a) { return function (t) { return 1 + a * Math.cos(n * (t + Math.PI / 2)); }; }
function tri(n, lo) { return function (t) { var u = mod(n * (t + Math.PI / 2) / TWO_PI, 1); return lo + (1 - lo) * Math.abs(2 * u - 1); }; }
function petals(n, lo, pw) { return function (t) { return lo + (1 - lo) * Math.pow(Math.abs(Math.cos(n * (t + Math.PI / 2) / 2)), pw); }; }
function squircle(p) { return function (t) { var c = Math.abs(Math.cos(t)), s = Math.abs(Math.sin(t)); return Math.pow(Math.pow(c, p) + Math.pow(s, p), -1 / p); }; }
function ellipse(a, b, rot) { return function (t) { var f = t - rot; return a * b / Math.sqrt(Math.pow(b * Math.cos(f), 2) + Math.pow(a * Math.sin(f), 2)); }; }
function polyRadius(pts, cx, cy) {
    return function (t) {
        var dx = Math.cos(t), dy = Math.sin(t), best = 0;
        for (var i = 0; i < pts.length; i++) {
            var p = pts[i], q = pts[(i + 1) % pts.length];
            var ex = q[0] - p[0], ey = q[1] - p[1];
            var den = dx * ey - dy * ex;
            if (Math.abs(den) < 1e-9) continue;
            var px = p[0] - cx, py = p[1] - cy;
            var tt = (px * ey - py * ex) / den;
            var s = (px * dy - py * dx) / den;
            if (tt > 1e-9 && s >= -1e-9 && s <= 1 + 1e-9) best = Math.max(best, tt);
        }
        return best;
    };
}
function heartPts() {
    var a = [];
    for (var t = 0; t < TWO_PI; t += 0.05)
        a.push([16 * Math.pow(Math.sin(t), 3) / 17, -(13 * Math.cos(t) - 5 * Math.cos(2 * t) - 2 * Math.cos(3 * t) - Math.cos(4 * t)) / 17]);
    return a;
}
function archPts() {
    var a = [];
    for (var s = Math.PI; s < TWO_PI; s += Math.PI / 18) a.push([Math.cos(s), Math.sin(s)]);
    a.push([1, 1]); a.push([-1, 1]);
    return a;
}
var defs = {
    circle:   function () { return make(function () { return 1; }, 0, 0); },
    square:   function () { return make(squircle(5), 0, 0); },
    triangle: function () { return make(poly(3), 4, 2); },
    pentagon: function () { return make(poly(5), 3, 2); },
    hexagon:  function () { return make(poly(6), 3, 2); },
    diamond:  function () { return make(polyRadius([[0, -1], [0.72, 0], [0, 1], [-0.72, 0]], 0, 0), 3, 2); },
    oval:     function () { return make(ellipse(1, 0.62, -0.7), 0, 0); },
    arch:     function () { return make(polyRadius(archPts(), 0, 0.15), 3, 2); },
    clover4:  function () { return make(petals(4, 0.55, 1), 1, 1); },
    cookie6:  function () { return make(waves(6, 0.07), 0, 0); },
    cookie9:  function () { return make(waves(9, 0.055), 0, 0); },
    cookie12: function () { return make(waves(12, 0.045), 0, 0); },
    sunny:    function () { return make(tri(8, 0.74), 2, 2); },
    burst:    function () { return make(tri(12, 0.6), 1, 1); },
    flower:   function () { return make(petals(8, 0.42, 0.8), 1, 1); },
    heart:    function () { return make(polyRadius(heartPts(), 0, 0.12), 2, 2); }
};
var names = ["circle", "square", "triangle", "pentagon", "hexagon", "diamond", "oval", "arch",
             "clover4", "cookie6", "cookie9", "cookie12", "sunny", "burst", "flower", "heart"];
var cache = {};
function get(name) {
    if (!cache[name]) cache[name] = (defs[name] || defs.circle)();
    return cache[name];
}
function lerp(a, b, t) {
    var o = [];
    for (var i = 0; i < N; i++) o.push(Math.max(0.15, a[i] + (b[i] - a[i]) * t));
    return o;
}
