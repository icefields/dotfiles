-----------------------------------------------------
-- ----------------------------------------------- --
--   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄   --
--  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌  --
--  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌  --
--   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀   --
-- ----------------------------------------------- --
-- ----- Luci4 Custom Theme for Awesome WM ------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------

-- LUCI4 COLOUR THEME
local colours = {
    black = "#000000",
    red = "#91231c",
    green = "#65726f",
    badass = { -- source https://www.color-hex.com/color/bada55
        main = "#bada55",
        shade1 = "#a7c44c",
        shade2 = "#94ae44",
        shade3 = "#82983b",
        shade4 = "#6f8233",
        shade6 = "#4a5722",
        shade8 = "#252b11",
        shade9 = "#121508",
        tint1 = "#c0dd66"
    },
    dead = { -- source https://www.color-hex.com/color/ffdead
        main = "#ffdead",
        shade2 = "#ccb18a",
        shade4 = "#998567",
        shade5 = "#7f6f56",
        shade6 = "#665845",
        shade7 = "#4c4233",
        shade8 = "#332c22",
        shade9 = "#191611",
        tint5 = "#ffeed6",
        tint6 = "#fff1de"
    },
    ash = { -- source https://www.color-hex.com/color/a1b1b5
        main = "#a1b1b5",
        shade1 = "#909fa2",
        shade2 = "#808d90",
        shade3 = "#707b7e",
        shade4 = "#606a6c",
        shade5 = "#50585a",
        shade6 = "#404648",
        shade7 = "#303536",
        shade8 = "#202324",
        shade9 = "#101112",
        tint1 = "#aab8bc",
        tint2 = "#b3c0c3",
        tint3 = "#bdc8cb",
        tint4 = "#c6d0d2",
        tint5 = "#d0d8da",
        tint6 = "#d9dfe1",
        tint7 = "#e2e7e8",
        tint8 = "#eceff0",
        tint9 = "#f5f7f7"
    },
    slate = { -- source https://www.color-hex.com/color/34616e
        main = "#34616e",
        shade1 = "#2e5763",
        shade2 = "#294d58",
        shade3 = "#24434d",
        shade4 = "#1f3a42",
        shade5 = "#1a3037",
        shade6 = "#14262c",
        shade7 = "#0f1d21",
        shade8 = "#0a1316",
        shade9 = "#05090b",
        tint1 = "#48707c",
        tint2 = "#5c808b",
        tint3 = "#709099",
        tint4 = "#85a0a8",
        tint5 = "#99b0b6",
        tint6 = "#adbfc5",
        tint7 = "#c2cfd3",
        tint8 = "#d6dfe2",
        tint9 = "#eaeff0"
    },
    teal = { -- https://www.color-hex.com/color/4980ac
        main = "#4980ac",
        shade1 = "#41739a",
        shade2 = "#3a6689",
        shade3 = "#335978",
        shade4 = "#2b4c67",
        shade5 = "#244056",
        shade6 = "#1d3344",
        shade7 = "#152633",
        shade8 = "#0e1922",
        shade9 = "#070c11",
        tint1 = "#5b8cb4",
        tint2 = "#6d99bc",
        tint3 = "#7fa6c4",
        tint4 = "#91b2cd",
        tint5 = "#a4bfd5",
        tint6 = "#b6ccdd",
        tint7 = "#c8d8e6",
        tint8 = "#dae5ee",
        tint9 = "#ecf2f6"
    }
}
-- END LUCI4 Colour Theme
return colours
