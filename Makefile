MAKEFLAGS += --silent

AWS_REGION = ap-southeast-1

autoformat:
	terraform fmt

TEST_TFVARS_FILE=test.tfvars
validate:
	find . -type f -name "$(TEST_TFVARS_FILE)" -exec dirname {} \;  | grep -v ".terraform" | sort -u | while read m; do \
		echo -n "Checking '$$m': "; \
		( \
			cd "$$m" && \
			export AWS_REGION=$(AWS_REGION) && \
			terraform init -backend=false -input=false > /dev/null && \
			terraform validate -var-file "$(TEST_TFVARS_FILE)" \
		) && echo "[✔]" || exit 1 ; \
	done

check-format:
	if ! terraform fmt --check --diff; then \
		echo "Some terraform files need be formatted, run 'make autoformat' to fix"; \
		exit 1; \
	else \
		echo "OK"; \
	fi

setup-git-hook: .git/hooks/pre-commit
.git/hooks/pre-commit:
	echo "#!/bin/sh" > $@
	echo "terraform fmt | xargs git add" >> $@
	chmod +x $@

PHONY: autoformat validate check-format
