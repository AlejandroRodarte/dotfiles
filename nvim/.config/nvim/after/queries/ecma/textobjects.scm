; extends

; note: already exists in ~/.local/share/nvim/lazy/nvim-treesitter-textobjects/queries/ecma/textobjects.scm with @assignment capture groups instead of @property
(object
  (pair
    key: (_) @property.lhs
    value: (_) @property.inner @property.rhs) @property.outer)
