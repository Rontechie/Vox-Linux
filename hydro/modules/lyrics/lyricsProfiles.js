.pragma library


var profiles = {
    "default": {
        label: "Theme", icon: "palette",
        size: 1.0,
        line: { font: "theme", weight: 700, uppercase: false, spacing: 0 },
        fill: "theme", rest: "themeText", restAlpha: 0.28,
        singing: { color: "#ffffff" },
        glow: { color: "theme", radius: 7, strength: 0.55 },
        echo: "none",
        stage: null
    },

    "cinematic": {
        label: "Cinematic", icon: "movie",
        size: 1.2,
        line: { font: "heavy", weight: 400, uppercase: true, spacing: 1 },
        fill: "#ffffff", rest: "#ffffff", restAlpha: 0.26, activeRestAlpha: 0.48,
        singing: { color: "#ffffff" },
        glow: { color: "#ffffff", radius: 14, strength: 0.7 },
        lineGlow: { color: "#ffffff", radius: 12, strength: 0.45 },
        echo: "none",
        stage: {
            giant: { font: "serif", weight: 900, uppercase: true, color: "#c0141f", opacity: 0.42 },
            accent: null
        }
    },

    "neon": {
        label: "Neon", icon: "local_fire_department",
        size: 1.55,
        line: { font: "heavy", weight: 400, uppercase: true, spacing: 1 },
        fill: "#ff6b7d", rest: "#ff6b7d", restAlpha: 0.22, activeRestAlpha: 0.55,
        singing: { color: "#ffd6db" },
        glow: { color: "#ff1f3d", radius: 18, strength: 0.9 },
        lineGlow: { color: "#ff1f3d", radius: 16, strength: 0.75 },
        echo: "none",
        stage: null
    },

    "editorial": {
        label: "Editorial", icon: "auto_stories",
        size: 1.12,
        line: { font: "serif", weight: 500, uppercase: false, spacing: 0 },
        fill: "#f3e3cc", rest: "#f3e3cc", restAlpha: 0.30,
        singing: { color: "#ffffff" },
        glow: null,
        echo: "none",
        stage: {
            giant: { font: "serif", weight: 700, uppercase: true, color: "#f3e3cc", opacity: 0.09 },
            accent: { font: "script", color: "#e7a0a0", opacity: 0.55, offset: 0.14, size: 0.24, glow: null }
        }
    },

    "nocturne": {
        label: "Nocturne", icon: "dark_mode",
        size: 1.12,
        line: { font: "serif", weight: 600, uppercase: false, spacing: 0 },
        fill: "#ffffff", rest: "#ffffff", restAlpha: 0.28,
        singing: { color: "#ffffff" },
        glow: { color: "#ffffff", radius: 10, strength: 0.6 },
        lineGlow: { color: "#ffffff", radius: 10, strength: 0.4 },
        echo: "none",
        stage: {
            giant: null,
            accent: { font: "brush", color: "#c77dff", opacity: 0.9, offset: 0.26, size: 0.2,
                      glow: { color: "#a855f7", radius: 16, strength: 0.85 } }
        }
    },

    "neonScript": {
        label: "Neon script", icon: "flare",
        size: 1.4,
        line: { font: "signature", weight: 400, uppercase: false, spacing: 0 },
        fill: "#ffffff", rest: "#ffffff", restAlpha: 0.30, activeRestAlpha: 0.55,
        singing: { color: "#ffffff" },
        glow: { color: "#29b6ff", radius: 16, strength: 0.85 },
        lineGlow: { color: "#29b6ff", radius: 12, strength: 0.5 },
        echo: "outline",
        outline: { color: "#29b6ff", opacity: 0.5, dx: 5, dy: 4 },
        stage: null
    }
};

profiles["kinetic"] = {
    label: "Edit", icon: "motion_photos_on",
    mode: "kinetic",
    sectionGap: 6.0,
    linesPerLook: 4,
    looks: [
        { font: "heavy", uppercase: true, color: "#ffffff", size: 1.0, tint: "#b0101c",
          glow: { color: "#ff2a3a", radius: 14 }, enter: "slam", exit: "zoom" },
        { font: "serif", uppercase: false, color: "#f3e3cc", size: 1.05, tint: "#8a6a4a",
          glow: null, enter: "rise", exit: "lift" },
        { font: "signature", uppercase: false, color: "#ffffff", size: 1.25, tint: "#0b6fa8",
          glow: { color: "#29b6ff", radius: 16 }, enter: "drop", exit: "flicker" },
        { font: "heavy", uppercase: true, color: "#ffe14d", size: 0.95, tint: "#a85a00",
          glow: { color: "#ff9d00", radius: 12 }, outline: "#3a1c00", enter: "pop", exit: "spin" },
        { font: "brush", uppercase: false, color: "#e3c2ff", size: 1.15, tint: "#5b1f8f",
          glow: { color: "#a855f7", radius: 16 }, enter: "swing", exit: "fade" }
    ],
    line: { font: "heavy", weight: 400, uppercase: true, spacing: 0 },
    fill: "#ffffff", rest: "#ffffff", restAlpha: 0.3,
    singing: { color: "#ffffff" }, glow: null, echo: "none", stage: null
};

profiles["motion"] = {
    label: "Motion", icon: "animation",
    mode: "kinetic",
    sectionGap: 6.0,
    linesPerLook: 4,
    looks: [
        { font: "heavy", uppercase: true, color: "#ffffff", size: 1.0, tint: "#b0101c",
          glow: { color: "#ff2a3a", radius: 14 }, enter: "slam", exit: "zoom",
          accent: { font: "serif", uppercase: true, color: "#ff3b47", size: 1.45,
                    glow: { color: "#8a0010", radius: 18 }, enter: "rise" } },
        { font: "serif", uppercase: false, color: "#f3e3cc", size: 1.05, tint: "#8a6a4a",
          glow: null, enter: "rise", exit: "lift",
          accent: { font: "script", uppercase: false, color: "#e7a0a0", size: 1.7, tilt: -6,
                    glow: null, enter: "swing" } },
        { font: "signature", uppercase: false, color: "#ffffff", size: 1.25, tint: "#0b6fa8",
          glow: { color: "#29b6ff", radius: 16 }, enter: "drop", exit: "flicker",
          accent: { font: "heavy", uppercase: true, color: "#ffffff", size: 0.95,
                    glow: { color: "#29b6ff", radius: 18 }, enter: "slam" } },
        { font: "heavy", uppercase: true, color: "#ffe14d", size: 0.95, tint: "#a85a00",
          glow: { color: "#ff9d00", radius: 12 }, outline: "#3a1c00", enter: "pop", exit: "spin",
          accent: { font: "brush", uppercase: false, color: "#ffffff", size: 1.5, tilt: -5,
                    glow: { color: "#ff7a00", radius: 16 }, enter: "pop" } },
        { font: "serif", uppercase: false, color: "#ffffff", size: 1.05, tint: "#5b1f8f",
          glow: { color: "#ffffff", radius: 10 }, enter: "rise", exit: "fade",
          accent: { font: "brush", uppercase: false, color: "#c77dff", size: 1.5, tilt: -4,
                    glow: { color: "#a855f7", radius: 18 }, enter: "swing" } }
    ],
    line: { font: "heavy", weight: 400, uppercase: true, spacing: 0 },
    fill: "#ffffff", rest: "#ffffff", restAlpha: 0.3,
    singing: { color: "#ffffff" }, glow: null, echo: "none", stage: null
};

profiles["reel"] = {
    label: "Reel", icon: "theaters",
    mode: "kinetic",
    sectionGap: 6.0,
    linesPerLook: 4,
    camera: { push: 0.07, punch: 0.06, shake: 7 },
    looks: [
        { id: "hit", label: "Hit", font: "heavy", uppercase: true, color: "#ffffff", highlight: "#ff3b47", size: 1.0, tint: "#b0101c",
          glow: { color: "#ff2a3a", radius: 14 }, letters: true, cut: "zoomIn", enter: "slam", exit: "through", punch: 1.0,
          accent: { font: "serif", uppercase: true, color: "#ff3b47", size: 1.4,
                    glow: { color: "#8a0010", radius: 18 }, enter: "slam" } },
        { id: "focus", label: "Focus", font: "serif", uppercase: false, color: "#f3e3cc", highlight: "#ffd27a", size: 1.05, tint: "#8a6a4a",
          glow: null, letters: true, enter: "focus", exit: "blur", punch: 0.45,
          accent: { font: "script", uppercase: false, color: "#e7a0a0", size: 1.7, tilt: -6,
                    glow: null, enter: "focus" } },
        { id: "sign", label: "Sign", font: "signature", uppercase: false, color: "#ffffff", highlight: "#9fe8ff", size: 1.25, tint: "#0b6fa8",
          glow: { color: "#29b6ff", radius: 16 }, letters: true, cut: "wipe", enter: "type", exit: "glitch", punch: 0.6,
          accent: { font: "heavy", uppercase: true, color: "#ffffff", size: 0.95,
                    glow: { color: "#29b6ff", radius: 18 }, enter: "slam" } },
        { id: "scatter", label: "Scatter", font: "heavy", uppercase: true, color: "#ffe14d", highlight: "#ffffff", size: 0.95, tint: "#a85a00",
          glow: { color: "#ff9d00", radius: 12 }, outline: "#3a1c00", letters: true, enter: "scatter", exit: "shatter",
          punch: 0.8,
          accent: { font: "brush", uppercase: false, color: "#ffffff", size: 1.5, tilt: -5,
                    glow: { color: "#ff7a00", radius: 16 }, enter: "cascade" } },
        { id: "whip", label: "Whip", font: "brush", uppercase: false, color: "#e3c2ff", highlight: "#ffffff", size: 1.15, tint: "#5b1f8f",
          glow: { color: "#a855f7", radius: 16 }, letters: true, cut: "push", layout: "stagger", enter: "cascade", exit: "whip",
          punch: 0.7,
          accent: { font: "heavy", uppercase: true, color: "#ffffff", size: 1.0,
                    glow: { color: "#a855f7", radius: 18 }, enter: "slam" } },
        { id: "poster", label: "Poster", font: "poster", uppercase: true, color: "#ffffff", highlight: "#ff2a6d", size: 1.15, tint: "#3a0018",
          glow: { color: "#ff2a6d", radius: 10 }, letters: true, enter: "stretch", exit: "split", punch: 0.9,
          accent: { font: "script", uppercase: false, color: "#ff8fb1", size: 1.6, tilt: -7,
                    glow: { color: "#ff2a6d", radius: 16 }, enter: "cascade" } },
        { id: "gothic", label: "Gothic", font: "gothic", uppercase: false, color: "#f4e9e9", highlight: "#ff2424", size: 1.2, tint: "#420000",
          glow: { color: "#ff0000", radius: 14 }, letters: true, cut: "tilt", enter: "flip", exit: "fall", punch: 0.85,
          accent: { font: "heavy", uppercase: true, color: "#ffffff", size: 0.9,
                    glow: { color: "#ff1a1a", radius: 18 }, enter: "slam" } },
        { id: "retro", label: "Retro", font: "retro", uppercase: true, color: "#ff7ad9", highlight: "#ffffff", size: 0.85, tint: "#5c0a52",
          glow: { color: "#ff3cc7", radius: 16 }, letters: true, cut: "iris", enter: "zoom", exit: "dissolve", punch: 0.55,
          accent: { font: "signature", uppercase: false, color: "#7af3ff", size: 1.7, tilt: -6,
                    glow: { color: "#00d5ff", radius: 16 }, enter: "wave" } },
        { id: "wave", label: "Wave", font: "signature", uppercase: false, color: "#c4fff4", highlight: "#ffffff", size: 1.3, tint: "#06574a",
          glow: { color: "#2ef2c8", radius: 16 }, letters: true, enter: "wave", exit: "flip", punch: 0.5,
          accent: { font: "poster", uppercase: true, color: "#ffffff", size: 1.0,
                    glow: { color: "#2ef2c8", radius: 14 }, enter: "stretch" } },
        { id: "split", label: "Split", font: "poster", uppercase: true, color: "#ffe14d", highlight: "#ffffff", size: 1.1, tint: "#5a4000",
          glow: null, outline: "#000000", letters: true, layout: "stagger", enter: "split", exit: "through",
          punch: 0.95,
          accent: { font: "gothic", uppercase: false, color: "#ffffff", size: 1.5,
                    glow: { color: "#ffb000", radius: 14 }, enter: "drop" } },
        { id: "ice", label: "Ice", font: "serif", uppercase: true, color: "#e2f6ff", highlight: "#79d4ff", size: 1.0, tint: "#0b3566",
          glow: { color: "#79d4ff", radius: 12 }, letters: true, cut: "drop", enter: "drop", exit: "fall", punch: 0.6,
          accent: { font: "script", uppercase: false, color: "#ffffff", size: 1.7, tilt: -5,
                    glow: { color: "#79d4ff", radius: 16 }, enter: "focus" } },
        { id: "follow", label: "Follow", font: "poster", uppercase: true, color: "#ffffff", highlight: "#5ef0ff", size: 1.5, tint: "#0d3a3a",
          glow: { color: "#5ef0ff", radius: 10 }, letters: true, follow: true, enter: "slam", exit: "through",
          punch: 0.5,
          accent: { font: "brush", uppercase: false, color: "#5ef0ff", size: 1.3, tilt: -5,
                    glow: { color: "#00c8ff", radius: 14 }, enter: "cascade" } },
        { id: "followSerif", label: "Follow serif", font: "serif", uppercase: false, color: "#fff4e3", highlight: "#ffcf8a", size: 1.5, tint: "#5a3a1a",
          glow: { color: "#ffb35c", radius: 10 }, letters: true, follow: true, enter: "focus", exit: "blur",
          punch: 0.3,
          accent: { font: "script", uppercase: false, color: "#ffcf8a", size: 1.5, tilt: -6,
                    glow: { color: "#ff9d3c", radius: 14 }, enter: "focus" } },
        { id: "comic", label: "Comic", font: "comic", uppercase: true, color: "#ffd23f", highlight: "#ffffff",
          size: 1.2, tint: "#7a5a00", glow: null, outline: "#141414", letters: true, enter: "elastic",
          exit: "explode", punch: 1.0,
          accent: { font: "comic", uppercase: true, color: "#ff4b3e", size: 1.35, tilt: -6, glow: null,
                    enter: "elastic" } },
        { id: "marker", label: "Marker", font: "marker", uppercase: false, color: "#f4f4f2", highlight: "#4d8dff",
          size: 1.1, tint: "#1d3a6b", glow: { color: "#4d8dff", radius: 8 }, letters: true, enter: "rain",
          exit: "evaporate", punch: 0.5,
          accent: { font: "marker", uppercase: true, color: "#4d8dff", size: 1.4, tilt: -4,
                    glow: { color: "#4d8dff", radius: 12 }, enter: "pendulum" } },
        { id: "tumble", label: "Tumble", font: "poster", uppercase: true, color: "#f6f3ee", highlight: "#e8445a",
          size: 1.2, tint: "#5a1020", glow: { color: "#e8445a", radius: 8 }, letters: true, enter: "tumble",
          exit: "squash", punch: 0.8,
          accent: { font: "poster", uppercase: true, color: "#e8445a", size: 1.3,
                    glow: { color: "#e8445a", radius: 14 }, enter: "slam" } },
        { id: "orbit", label: "Orbit", font: "heavy", uppercase: true, color: "#effff7", highlight: "#2ee59d",
          size: 0.95, tint: "#0b5a3c", glow: { color: "#2ee59d", radius: 10 }, letters: true, enter: "orbit",
          exit: "spinout", punch: 0.55,
          accent: { font: "signature", uppercase: false, color: "#2ee59d", size: 1.6, tilt: -5,
                    glow: { color: "#18b97a", radius: 14 }, enter: "focus" } },
        { id: "static", label: "Static", font: "poster", uppercase: true, color: "#f2f2f2", highlight: "#ff3b30",
          size: 1.15, tint: "#3a0a08", glow: { color: "#ff3b30", radius: 8 }, letters: true, enter: "jitter",
          exit: "glitch", punch: 0.9,
          accent: { font: "marker", uppercase: false, color: "#ff3b30", size: 1.4, tilt: -6,
                    glow: { color: "#ff3b30", radius: 12 }, enter: "jitter" } },
        { id: "swing", label: "Swing", font: "brush", uppercase: false, color: "#fff3e8", highlight: "#ff7a1a",
          size: 1.2, tint: "#6a2e00", glow: { color: "#ff7a1a", radius: 10 }, letters: true, enter: "pendulum",
          exit: "fall", punch: 0.6,
          accent: { font: "poster", uppercase: true, color: "#ff7a1a", size: 1.0,
                    glow: { color: "#ff7a1a", radius: 14 }, enter: "tumble" } },
        { id: "rewind", label: "Rewind", font: "heavy", uppercase: true, color: "#f2f2f2", highlight: "#2f6bff",
          size: 1.0, tint: "#0d1f4a", glow: { color: "#2f6bff", radius: 8 }, letters: true, enter: "type",
          exit: "rewind", punch: 0.7,
          accent: { font: "comic", uppercase: true, color: "#2f6bff", size: 1.4,
                    glow: { color: "#2f6bff", radius: 12 }, enter: "elastic" } },
        { id: "followComic", label: "Follow comic", font: "comic", uppercase: true, color: "#ffd23f",
          highlight: "#ffffff", size: 1.6, tint: "#7a5a00", glow: null, outline: "#141414", letters: true,
          follow: true, enter: "elastic", exit: "explode", punch: 0.6,
          accent: { font: "comic", uppercase: true, color: "#ff4b3e", size: 1.25, tilt: -5, glow: null,
                    enter: "elastic" } },
        { id: "decode", label: "Decode", font: "heavy", uppercase: true, color: "#eef2ee", highlight: "#ffb020",
          size: 0.95, tint: "#4a3000", glow: { color: "#ffb020", radius: 8 }, letters: true, enter: "scramble",
          exit: "scrambleOut", cut: "wipe", punch: 0.5,
          accent: { font: "poster", uppercase: true, color: "#ffb020", size: 1.35,
                    glow: { color: "#ffb020", radius: 12 }, enter: "scramble" } },
        { id: "lean", label: "Lean", font: "poster", uppercase: true, color: "#f5f5f5", highlight: "#ff2d55",
          size: 1.2, tint: "#4a0014", glow: { color: "#ff2d55", radius: 8 }, letters: true, enter: "lean",
          exit: "drift", cut: "push", punch: 0.8,
          accent: { font: "brush", uppercase: false, color: "#ff2d55", size: 1.5, tilt: -6,
                    glow: { color: "#ff2d55", radius: 12 }, enter: "lean" } },
        { id: "strobe", label: "Strobe", font: "heavy", uppercase: true, color: "#ffffff", highlight: "#c6ff3d",
          size: 1.0, tint: "#2c3a00", glow: { color: "#c6ff3d", radius: 10 }, letters: true, enter: "strobe",
          exit: "iris", cut: "iris", punch: 1.0,
          accent: { font: "comic", uppercase: true, color: "#c6ff3d", size: 1.4,
                    glow: { color: "#c6ff3d", radius: 14 }, enter: "strobe" } },
        { id: "banner", label: "Banner", font: "gothic", uppercase: false, color: "#f3e7d3", highlight: "#e0a526",
          size: 1.25, tint: "#4a3100", glow: { color: "#e0a526", radius: 10 }, letters: true, enter: "unfold",
          exit: "melt", cut: "zoomIn", punch: 0.6,
          accent: { font: "heavy", uppercase: true, color: "#e0a526", size: 0.9,
                    glow: { color: "#e0a526", radius: 14 }, enter: "slam" } },
        { id: "conveyor", label: "Conveyor", font: "poster", uppercase: true, color: "#f2f2f2", highlight: "#ff6a00",
          size: 1.15, tint: "#4a1f00", glow: { color: "#ff6a00", radius: 8 }, letters: true, enter: "conveyor",
          exit: "implode", cut: "tilt", punch: 0.7,
          accent: { font: "marker", uppercase: false, color: "#ff6a00", size: 1.4, tilt: -5,
                    glow: { color: "#ff6a00", radius: 12 }, enter: "spring" } },
        { id: "spring", label: "Spring", font: "comic", uppercase: true, color: "#ffffff", highlight: "#ff4fa3",
          size: 1.2, tint: "#5a0a34", glow: null, outline: "#1a1a1a", letters: true, enter: "spring",
          exit: "wipe", cut: "drop", punch: 0.9,
          accent: { font: "comic", uppercase: true, color: "#ff4fa3", size: 1.35, tilt: -5, glow: null,
                    enter: "elastic" } }
    ],
    line: { font: "heavy", weight: 400, uppercase: true, spacing: 0 },
    fill: "#ffffff", rest: "#ffffff", restAlpha: 0.3,
    singing: { color: "#ffffff" }, glow: null, echo: "none", stage: null
};

var letterMotion = {
    slam:    { scale: 2.6, x: 0, y: 0, rot: 0, spread: 0, dur: 170, stagger: 16, ease: "OutQuad" },
    cascade: { scale: 1.35, x: 0, y: -0.75, rot: 0, spread: 0, dur: 440, stagger: 34, ease: "OutBack" },
    scatter: { scale: 0.5, x: 0, y: 0, rot: 55, spread: 1.4, dur: 560, stagger: 10, ease: "OutExpo" },
    type:    { scale: 1.3, x: 0, y: 0, rot: 0, spread: 0, dur: 80, stagger: 30, ease: "Linear" },
    focus:   { scale: 1.15, x: 0, y: 0.3, rot: 0, spread: 0, dur: 500, stagger: 20, ease: "OutExpo", blur: true },
    rise:    { scale: 1.0, x: 0, y: 0.5, rot: 0, spread: 0, dur: 360, stagger: 22, ease: "OutCubic" },
    flip:    { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, flip: 90, dur: 420, stagger: 40, ease: "OutBack" },
    stretch: { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, sy: 2.4, dur: 460, stagger: 24, ease: "OutBack" },
    split:   { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, alt: 1.6, dur: 380, stagger: 14, ease: "OutExpo" },
    wave:    { scale: 0.8, x: 0, y: 0, rot: 18, spread: 0, altY: 0.9, dur: 520, stagger: 30, ease: "OutBack" },
    zoom:    { scale: 0.05, x: 0, y: 0, rot: 0, spread: 0, dur: 520, stagger: 26, ease: "OutExpo", blur: true },
    drop:    { scale: 1.0, x: 0, y: -1.6, rot: 0, spread: 0, dur: 620, stagger: 38, ease: "OutBounce" },
    elastic: { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, sx: 0.05, dur: 700, stagger: 22, ease: "OutElastic" },
    rain:    { scale: 1.0, x: 0, y: -1.2, rot: 8, spread: 0, scatterDelay: 320, dur: 420, stagger: 12, ease: "OutCubic" },
    tumble:  { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, flipX: -100, dur: 460, stagger: 32, ease: "OutBack" },
    orbit:   { scale: 0.6, x: 0, y: 0, rot: 120, spread: 0, orbit: 1.6, dur: 640, stagger: 24, ease: "OutCubic" },
    jitter:  { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, jitter: 0.45, dur: 380, stagger: 18, ease: "OutQuad" },
    pendulum: { scale: 1.0, x: 0, y: 0, rot: -75, spread: 0, hang: true, dur: 760, stagger: 40, ease: "OutElastic" },
    scramble: { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, scramble: true, dur: 640, stagger: 34, ease: "Linear" },
    lean:    { scale: 1.0, x: -1.1, y: 0, rot: 0, spread: 0, lean: 0.9, dur: 420, stagger: 22, ease: "OutCubic" },
    strobe:  { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, strobe: true, dur: 420, stagger: 30, ease: "Linear" },
    unfold:  { scale: 1.0, x: 0, y: 0, rot: 0, spread: 0, sy: 0.02, sx: 1, unfold: true, dur: 440, stagger: 28, ease: "OutBack" },
    conveyor: { scale: 1.0, x: -2.6, y: 0, rot: 0, spread: 0, dur: 480, stagger: 34, ease: "OutCubic" },
    spring:  { scale: 1.0, x: 0, y: 1.3, rot: 0, spread: 0, dur: 760, stagger: 30, ease: "OutElastic" }
};

var order = ["default", "cinematic", "neon", "editorial", "nocturne", "neonScript", "kinetic", "motion", "reel"];

function merge(base, over) {
    var out = {};
    var key;
    for (key in base)
        out[key] = base[key];
    for (key in over) {
        var value = over[key];
        if (value && typeof value === "object" && !Array.isArray(value)
                && base[key] && typeof base[key] === "object")
            out[key] = merge(base[key], value);
        else
            out[key] = value;
    }
    return out;
}

function resolve(name, custom) {
    if (name === "custom")
        return merge(profiles["default"], custom || {});
    return profiles[name] || profiles["default"];
}
