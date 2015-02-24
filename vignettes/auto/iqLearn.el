(TeX-add-style-hook
 "iqLearn"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8x")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art12"
    "fullpage"
    "natbib"
    "amssymb"
    "hyperref"
    "graphicx"
    "inputenc"
    "amsmath"
    "amsthm"
    "bbm"
    "Sweave")
   (TeX-add-symbols
    '("pkg" 1)
    '("code" 1)
    '("proglang" 1)
    '("bma" 1)
    "T"
    "bX"
    "bx"
    "bH"
    "bh")
   (LaTeX-add-labels
    "smart"
    "q1fn"
    "iq1fn"
    "locationScaleDensity"
    "vars"
    "s2diag"
    "s1mainDiag"
    "s1cmDiag"
    "s1varDiag"
    "resids")
   (LaTeX-add-bibliographies
    "iq_cites")))

