.PHONY: repos latest
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes

# Display each repo along with the latest archive in that repo.
latest:
	@find repos -maxdepth 3 -mindepth 3 -type d | \
	while read repo; do echo -e "$$repo\t $$(borg list --short $$repo 2>/dev/null| tail -1)"; done

# Show all borg repos present, assuming a standard layout of repos/HOST/ROLE/default.
repos:
	@find repos -maxdepth 3 -mindepth 3 -type d
