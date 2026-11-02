import HeadComplexity
import HeadComplexity.Extensions.All

open HeadComplexity

-- Upstream declarations crosswalked to ARCH-001 .. ARCH-009
#print axioms HStar_eq_Lfrac
#print axioms SharedHStar_eq_Lfrac
#print axioms computableWithSharedHeadsN_iff_fracComputable
#print axioms HStar_eq_zero_iff
#print axioms HStar_eq_one_iff
#print axioms degree_le_of_computableWithHeadsN
#print axioms thresholdDeg_f10
#print axioms HStar_f10_ge_three
#print axioms f10_strict_separation
#print axioms HStar_le_weighted_sum
#print axioms HStar_le_universal_boolean
#print axioms HStar_symmetricFn
#print axioms HStar_parity
#print axioms signChanges_parity
#print axioms thresholdDeg_parity

-- Fork extensions EXT-001 .. EXT-004
#print axioms Ext.signChanges_le
#print axioms Ext.HStar_symmetricFn_le
#print axioms Ext.signChanges_not
#print axioms Ext.HStar_not_symmetricFn
#print axioms Ext.HStar_not_parity
#print axioms Ext.signChanges_eq_self_iff
#print axioms Ext.alternating_eq
#print axioms Ext.signChanges_eq_self_iff_parity
#print axioms Ext.HStar_symmetricFn_eq_self_iff
#print axioms Ext.signChanges_zero
#print axioms Ext.HStar_symmetricFn_zero_cases

-- Exact statements of the fork extensions
#check @Ext.signChanges_le
#check @Ext.HStar_symmetricFn_le
#check @Ext.signChanges_not
#check @Ext.HStar_not_symmetricFn
#check @Ext.HStar_not_parity
#check @Ext.signChanges_eq_self_iff
#check @Ext.signChanges_eq_self_iff_parity
#check @Ext.HStar_symmetricFn_eq_self_iff
#check @Ext.HStar_symmetricFn_zero_cases
