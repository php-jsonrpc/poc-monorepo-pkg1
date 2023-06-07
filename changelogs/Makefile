lint:
	@antsibull-changelog lint

_ensure_version_provided:
ifndef version
	@echo "❗ Err: You must provide the version as parameter"
	@echo "ℹ️  Ex: version=1.2.3"
	@exit 1
endif

create-entry: _ensure_version_provided
create-entry:
	antsibull-changelog release --version "${version}"

update-entry: _ensure_version_provided
update-entry:
	antsibull-changelog release --version "${version}" --update-existing
