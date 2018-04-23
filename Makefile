.PHONY: autoformat validate check-format

autoformat:
	terraform fmt

init: .terraform
.terraform:
	terraform init -input=false

validate: .terraform
	find . -type f -name "*.tf" -exec dirname {} \; | sort -u | while read m; do \
		echo -n "Checking '$$m': "; \
		(terraform validate -check-variables=false "$$m" && echo "√") || exit 1 ; \
	done

check-format: .terraform
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
