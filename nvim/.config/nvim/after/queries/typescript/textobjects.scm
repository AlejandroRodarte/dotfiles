; extends

(interface_body
  (property_signature
    name: (_) @property.lhs
    type: (type_annotation
      (_) @property.inner @property.rhs)) @property.outer)

(class_body
  (public_field_definition
    (accessibility_modifier)?
    name: (property_identifier) @property.lhs
    value: (_) @property.inner @property.rhs) @property.outer)
