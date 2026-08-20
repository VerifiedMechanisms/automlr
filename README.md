# automlr

A from-scratch attack on the head-complexity problem: what is the minimum number of attention heads $H^{\ast}(f)$ that a single-layer, attention-only transformer with a linear readout needs to compute a Boolean function $f$?

This repo deliberately starts with only the problem definition. No prior results, proofs, or surveys are carried over.

- [`problem_statement.md`](problem_statement.md): the problem, the central quantity $H^{\ast}(f)$, and the core questions.
- [`model.md`](model.md): the precise architecture (embeddings, attention heads, residual stream, readout, masking convention, deliberate simplifications).
