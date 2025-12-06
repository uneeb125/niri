#!/bin/sh

grim -g "$(slurp)"  "/home/$USER/.temp/clip" && tesseract "/home/$USER/.temp/clip" stdout | wl-copy
