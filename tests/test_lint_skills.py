"""Test suite for scripts/lint-skills — the seam is the CLI's exit code and stdout.

Run: python -m unittest discover -s tests -v
"""
import subprocess
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent


def run_lint(*args, cwd=None):
    """Run the lint script against the repo, return (returncode, stdout)."""
    script = str(REPO / "scripts" / "lint-skills")
    proc = subprocess.run(
        [sys.executable, script, *args],
        cwd=cwd or str(REPO),
        capture_output=True,
        text=True,
    )
    return proc.returncode, proc.stdout


class LintSkillsTests(unittest.TestCase):
    maxDiff = None

    def setUp(self):
        # The dead-link check is the first slice. Assert the CURRENT tree still
        # has the known dead link — this is the RED phase: the linter does not
        # yet exist, so calling it must not succeed.
        pass

    def test_lint_script_exists(self):
        """A lint-skills executable exists at scripts/lint-skills."""
        self.assertTrue((REPO / "scripts" / "lint-skills").exists())

    def test_clean_repo_passes(self):
        """For a well-formed single skill tree, lint exits 0 and prints PASS."""
        # Minimal fixture: one skill with a valid SKILL.md + resolving links.
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            skill = Path(tmp) / "engineering" / "sample"
            skill.mkdir(parents=True)
            (skill / "SKILL.md").write_text(
                "---\nname: sample\ndescription: A sample skill.\n---\n\n"
                "# Sample\n\nSee [help](help.md).\n",
                encoding="utf-8",
            )
            (skill / "help.md").write_text("# Help\n", encoding="utf-8")
            code, out = run_lint(cwd=tmp)
            self.assertEqual(code, 0, out)
            self.assertIn("PASS", out.upper())


if __name__ == "__main__":
    unittest.main()