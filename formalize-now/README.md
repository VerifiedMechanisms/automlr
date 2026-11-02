# formalize.now research fork: automlr

This directory turns the `thinkthoughts/automlr` fork into a formalize.now research project. It records how the paper's claims map onto the upstream Lean formalization, what this fork reproduced independently, and one completed fork extension. The contents are publication-ready documentation for a formalize.now Next Research page; nothing here is published or deployed.

## Paper

Karthik Viswanathan, Plamen Dimitrov, Stefano Rocca, Sarayu Sirikonda. *Formally Verified Autoresearch for Analyzing the Expressivity of Multi-Head Attention.* arXiv:2610.25341 (cs.CC), October 2026.

The paper studies a one-layer, attention-only transformer with additive positional embeddings and a linear readout. The head complexity $H^{\ast}(f)$ of a Boolean function $f$ is the least number of heads that represents it. The scope of every statement in this directory is that model and that measure.

## Scope of this fork

1. **Reproduction.** The upstream formalization at commit `33daec7fd0092d9215b9692c8241676a3c05a82e` was built and axiom-audited in this fork with the repository's own validator. See [VERIFICATION.md](VERIFICATION.md).
2. **Crosswalk.** Each paper claim (ARCH-001 to ARCH-009) is mapped to exact Lean declarations, keeping the paper's numbering and the Lean repository's numbering side by side. See [CROSSWALK.md](CROSSWALK.md).
3. **Fork extension.** EXT-001 to EXT-004 prove that, among symmetric Boolean functions on $n$ bits, parity and its complement are exactly the functions with $H^{\ast}(f) = n$. See `formalization/HeadComplexity/Extensions/`.

## Three kinds of evidence

This project keeps three levels of evidence distinct, and every RPI entry states which ones it has.

- **Paper-claimed:** stated in arXiv:2610.25341.
- **Upstream-formalized:** a Lean declaration exists in `VerifiedMechanisms/automlr` at the pinned commit.
- **Locally reproduced:** built, scanned for placeholders, and axiom-audited in this fork on 2026-11-02.

Fork extensions carry a fourth status, **fork-extension-verified**, meaning the result was written in this fork and passed the same checks.

## Main fork result

For every $n$, including $n = 0$, and every Hamming-weight profile $F$, the symmetric function $f(x) = F(|x|)$ satisfies

$$ H^{\ast}(f) = n \iff f = \mathrm{PARITY} \text{ or } f = \lnot \mathrm{PARITY}. $$

Lean: `HeadComplexity.Ext.HStar_symmetricFn_eq_self_iff`.

> **Scope.** This is a corollary of the upstream symmetric characterization (paper Theorem 5, Lean `HStar_symmetricFn`). It is a statement about symmetric Boolean functions in the paper's model. Non-symmetric functions can need more than $n$ heads (upper bound $2^n - 1$, Lean `HStar_le_universal_boolean`), so the result describes the top of the symmetric class only.

## Files

| File | Contents |
|---|---|
| [SOURCES.md](SOURCES.md) | Paper, upstream repository, pinned commit, concurrent research |
| [RPI.json](RPI.json) | Machine-readable Reading Point Identifiers with statuses and evidence |
| [CROSSWALK.md](CROSSWALK.md) | Paper statements mapped to exact Lean declarations |
| [VERIFICATION.md](VERIFICATION.md) | Build results, axiom audit, reproduction evidence, unchecked items |
| [ROADMAP.md](ROADMAP.md) | Next small, independently verifiable extensions |
| `PrintAxioms.lean` | Script that prints axioms and exact statements for every crosswalked declaration |
