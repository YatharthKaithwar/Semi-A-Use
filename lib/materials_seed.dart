const List<Map<String, Object?>> seedMaterials = [
  {
    "name": "Mercury",
    "formula": "Hg",
    "tc": 4.15,
    "type": "Type-I",
    "field": "Thermodynamic critical field Hc(0) ≈ 0.041 T",
    "description": "First material discovered to be superconducting, in 1911.",
    "applications": "Historical reference material for fundamental low-temperature physics experiments.",
    "note": "Ambient-pressure approximate value."
  },
  {
    "name": "Lead",
    "formula": "Pb",
    "tc": 7.2,
    "type": "Type-I",
    "field": "Thermodynamic critical field Hc(0) ≈ 0.080 T",
    "description": "A conventional elemental superconductor and classic example of Type-I behaviour.",
    "applications": "Meissner-effect demonstrations, low-temperature physics and reference experiments.",
    "note": "Ambient-pressure approximate value."
  },
  {
    "name": "Niobium",
    "formula": "Nb",
    "tc": 9.25,
    "type": "Type-II",
    "field": "Hc1(0) ≈ 0.17 T; Hc2(0) ≈ 0.4 T (representative approximate values).",
    "description": "An elemental Type-II superconductor with a relatively high Tc among pure metallic elements.",
    "applications": "Superconducting radio-frequency cavities in particle accelerators, research magnets and devices.",
    "note": "Values vary with purity, sample and measurement convention."
  },
  {
    "name": "Niobium-Titanium",
    "formula": "Nb-Ti",
    "tc": 9.2,
    "type": "Type-II",
    "field": "Upper critical field typically around 10–15 T at low temperature; composition-dependent.",
    "description": "A ductile superconducting alloy that can be made into long, flexible multifilamentary wires.",
    "applications": "MRI and NMR magnets, research magnets and particle-accelerator magnets.",
    "note": "Tc and field limits depend on alloy composition and processing."
  },
  {
    "name": "Niobium-Tin",
    "formula": "Nb₃Sn",
    "tc": 18.3,
    "type": "Type-II",
    "field": "Upper critical field can be roughly 25–30 T at low temperature; strain-dependent.",
    "description": "A high-field intermetallic superconductor. It is more brittle than Nb-Ti.",
    "applications": "High-field research magnets, fusion-magnet development and accelerator magnets.",
    "note": "Representative values; heat treatment and strain affect performance."
  },
  {
    "name": "Magnesium Diboride",
    "formula": "MgB₂",
    "tc": 39.0,
    "type": "Type-II",
    "field": "Anisotropic Hc2; roughly 15–35 T reported for different samples and orientations.",
    "description": "A binary compound discovered to superconduct at 39 K in 2001.",
    "applications": "Superconducting wires and cables, cryogen-free magnet research and energy-related systems under development.",
    "note": "Critical fields vary with sample quality, doping and orientation."
  },
  {
    "name": "Yttrium Barium Copper Oxide (YBCO)",
    "formula": "YBa₂Cu₃O₇−δ",
    "tc": 92.0,
    "type": "Type-II",
    "field": "Very high, strongly anisotropic upper critical field; depends on oxygen content and orientation.",
    "description": "A high-temperature cuprate superconductor. Optimally oxygenated material has Tc above liquid-nitrogen boiling temperature.",
    "applications": "High-temperature superconducting tapes, power cables, fault-current limiters, compact magnets and levitation demonstrations.",
    "note": "Approx. 90–93 K for common optimally oxygenated compositions."
  },
  {
    "name": "BSCCO-2212",
    "formula": "Bi₂Sr₂CaCu₂O₈+δ",
    "tc": 85.0,
    "type": "Type-II",
    "field": "Very high, strongly anisotropic upper critical field; no single universal value.",
    "description": "A layered bismuth-based cuprate that can be fabricated into round multifilamentary wires.",
    "applications": "High-field magnets, research conductors and superconducting wire development.",
    "note": "Approximate Tc; oxygen content and processing affect transition."
  },
  {
    "name": "BSCCO-2223",
    "formula": "Bi₂Sr₂Ca₂Cu₃O₁₀+δ",
    "tc": 110.0,
    "type": "Type-II",
    "field": "Very high and anisotropic upper critical field; depends on direction and sample.",
    "description": "A layered cuprate with a transition temperature around 110 K, used in practical HTS tapes.",
    "applications": "High-temperature superconducting tapes, power cables, current leads and demonstration devices.",
    "note": "Approximate optimally doped value; composition and oxygen content matter."
  },
  {
    "name": "Lanthanum Strontium Copper Oxide (LSCO)",
    "formula": "La₂−xSrₓCuO₄",
    "tc": 38.0,
    "type": "Type-II",
    "field": "Anisotropic, composition-dependent upper critical field; no single value applies to all doping levels.",
    "description": "A cuprate model system for studying doping and high-temperature superconductivity.",
    "applications": "Fundamental research into cuprate superconductivity and correlated-electron materials.",
    "note": "Maximum Tc around 38 K for selected strontium doping."
  },
  {
    "name": "Potassium-Doped Barium Iron Arsenide",
    "formula": "(Ba,K)Fe₂As₂",
    "tc": 38.0,
    "type": "Type-II",
    "field": "High, anisotropic upper critical field; depends on composition and field orientation.",
    "description": "An iron-based 122-family superconductor; potassium substitution induces superconductivity.",
    "applications": "Research into iron-based superconductors, high-field behaviour and unconventional mechanisms.",
    "note": "Tc near 38 K for selected optimally doped compositions."
  },
  {
    "name": "Hydrogen Sulfide (high pressure)",
    "formula": "H₃S",
    "tc": 203.0,
    "type": "Type-II",
    "field": "Critical-field behaviour is studied under extreme pressure; no single ambient-pressure value applies.",
    "description": "A hydrogen-rich phase formed under extreme pressure, superconducting near 203 K at about 150 GPa.",
    "applications": "Fundamental high-pressure superconductivity research and the search for higher-temperature superconductors.",
    "note": "Requires extreme pressure around 150 GPa; not stable as a superconductor at ambient pressure."
  }
];
