# Sources

## Primary paper

- Karthik Viswanathan, Plamen Dimitrov, Stefano Rocca, Sarayu Sirikonda. *Formally Verified Autoresearch for Analyzing the Expressivity of Multi-Head Attention.* arXiv:2610.25341, submitted 2026-10-18. <https://arxiv.org/abs/2610.25341>
- Copy bundled with the repository: `formally-verified-autoresearch-mha.pdf`. Every paper reference in this directory (theorem numbers, appendix letters, quoted conditions) was checked against this bundled copy. The arXiv PDF was rate-limited when fetched on 2026-11-02, so agreement between the two versions is unconfirmed.

## Formalization

| Role | Repository | Ref |
|---|---|---|
| Upstream | <https://github.com/VerifiedMechanisms/automlr> | `main` at `33daec7fd0092d9215b9692c8241676a3c05a82e` ("Made the linear fractional form stuff more explicit") |
| Fork | <https://github.com/thinkthoughts/automlr> | `main` identical to the upstream commit above; work on branch `formalize-now/symmetric-maximal` |

Toolchain pins at that commit: Lean `leanprover/lean4:v4.31.0` (`formalization/lean-toolchain`), Mathlib `v4.31.0` (`formalization/lakefile.toml`, locked in `formalization/lake-manifest.json`).

Upstream documentation used for the crosswalk: `theorems.md`, `theorems/`, `formalization/README.md`, `formalization/PROOF_OVERVIEW.md`, `formalization/BUILDING.md`, `formalization/HeadComplexity/Results/All.lean`.

## Concurrent and classical research

- Daniel Hsu and Mingyue Xu. *Attention-based representations for multi-task computation.* arXiv:2608.04243, 2026. They prove $DH \geq \deg _{\pm}(f)$ for an $H$-head layer with a degree-$D$ polynomial-threshold readout, exact for symmetric functions, in a model without positional embeddings. At $D = 1$ this matches paper Theorem 5. The paper discusses the relationship in its appendix "Relation to Concurrent Work by Hsu and Xu" (Appendix D in the bundled PDF; ARCH-008).
- Daniel Hsu. *Lower bounds for one-layer transformers that compute parity.* 2026. Cited by the paper as related parity lower bounds.
- James Aspnes, Richard Beigel, Merrick Furst, Steven Rudich. *The expressive power of voting polynomials.* Combinatorica, 1994. Lemma 2.6 gives the threshold degree of a symmetric function as its number of profile changes; the paper uses it for the lower bound of Theorem 5.
- Ramamohan Paturi. *On the degree of polynomials that approximate symmetric Boolean functions.* STOC 1992. Cited for the Hamming-weight profile representation.

## Tools

- Lean `comparator` (Lean FRO, <https://github.com/leanprover/comparator>). The paper's writeup names it as future work for checking agent-generated proofs against human-reviewed statements. It is not part of the upstream verification pipeline and was not run here (see VERIFICATION.md).
