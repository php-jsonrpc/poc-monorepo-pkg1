COLOR_ENABLED ?= true
TEST_OUTPUT_STYLE ?= dot

## DIRECTORY AND FILE
BUILD_DIRECTORY ?= build
PHPUNIT_COVERAGE_DIRECTORY ?= ${BUILD_DIRECTORY}/coverage-phpunit
PHPUNIT_UNIT_COVERAGE_FILE_PATH ?= ${PHPUNIT_COVERAGE_DIRECTORY}/unit.clover
PHPUNIT_FUNCTIONAL_COVERAGE_FILE_PATH ?= ${PHPUNIT_COVERAGE_DIRECTORY}/functional.clover
BEHAT_COVERAGE_DIRECTORY ?= ${BUILD_DIRECTORY}/coverage-behat
REPORTS_DIRECTORY ?= ${BUILD_DIRECTORY}/reports # Codestyle

## Commands options
### Phpcs
PHPCS_REPORT_STYLE ?= full
PHPCS_DISABLE_WARNING ?= "false"

# Enable/Disable color ouput
ifeq ("${COLOR_ENABLED}","true")
	PHPUNIT_COLOR_OPTION ?= --colors=always
	BEHAT_COLOR_OPTION ?= --colors
	PHPCS_COLOR_OPTION ?= --colors
	COMPOSER_COLOR_OPTION ?= --ansi
else
	PHPUNIT_COLOR_OPTION ?= --colors=never
	PHPCS_COLOR_OPTION ?= --no-colors
	BEHAT_COLOR_OPTION ?= --no-colors
	COMPOSER_COLOR_OPTION ?= --no-ansi
endif

ifeq ("${TEST_OUTPUT_STYLE}","pretty")
	PHPUNIT_OUTPUT_STYLE_OPTION ?= --testdox
	BEHAT_OUTPUT_STYLE_OPTION ?= --format pretty
else
	PHPUNIT_OUTPUT_STYLE_OPTION ?=
	BEHAT_OUTPUT_STYLE_OPTION ?= --format progress
endif

ifdef COVERAGE_OUTPUT_STYLE
	export XDEBUG_MODE=coverage
	ifeq ("${COVERAGE_OUTPUT_STYLE}","html")
		PHPUNIT_COVERAGE_OPTION ?= --coverage-html ${PHPUNIT_COVERAGE_DIRECTORY}
		PHPUNIT_FUNCTIONAL_COVERAGE_OPTION ?= --coverage-html ${PHPUNIT_COVERAGE_DIRECTORY}
		BEHAT_COVERAGE_OPTION ?= --profile coverage-html
	else ifeq ("${COVERAGE_OUTPUT_STYLE}","clover")
		PHPUNIT_COVERAGE_OPTION ?= --coverage-clover ${PHPUNIT_UNIT_COVERAGE_FILE_PATH}
		PHPUNIT_FUNCTIONAL_COVERAGE_OPTION ?= --coverage-clover ${PHPUNIT_FUNCTIONAL_COVERAGE_FILE_PATH}
		BEHAT_COVERAGE_OPTION ?= --profile coverage-clover
        else
		PHPUNIT_COVERAGE_OPTION ?= --coverage-text
		PHPUNIT_FUNCTIONAL_COVERAGE_OPTION ?= --coverage-text
		BEHAT_COVERAGE_OPTION ?= --profile coverage
	endif
endif

ifneq ("${PHPCS_REPORT_FILE}","")
	PHPCS_REPORT_FILE_OPTION ?= --report-file=${PHPCS_REPORT_FILE}
endif

ifneq ("${PHPCS_DISABLE_WARNING}","true")
	PHPCS_DISABLE_WARNING_OPTION=
else
	PHPCS_DISABLE_WARNING_OPTION=-n
endif

.PHONY: install
install:
	composer install

.PHONY: tests
tests: unit-tests functional-tests phpstan codestyle

.PHONY: unit-tests
ifdef PHPUNIT_COVERAGE_OPTION
unit-tests: create-build-directories
endif
unit-tests:
	./vendor/bin/phpunit ${PHPUNIT_COLOR_OPTION} ${PHPUNIT_OUTPUT_STYLE_OPTION} ${PHPUNIT_COVERAGE_OPTION} --testsuite technical

.PHONY: functional-tests
ifdef BEHAT_COVERAGE_OPTION
functional-tests: create-build-directories
else ifdef PHPUNIT_FUNCTIONAL_COVERAGE_OPTION
functional-tests: create-build-directories
endif
functional-tests:
	./vendor/bin/phpunit ${PHPUNIT_COLOR_OPTION} ${PHPUNIT_OUTPUT_STYLE_OPTION} ${PHPUNIT_FUNCTIONAL_COVERAGE_OPTION} --testsuite functional
	./vendor/bin/behat ${BEHAT_COLOR_OPTION} ${BEHAT_OUTPUT_STYLE_OPTION} ${BEHAT_COVERAGE_OPTION} --no-snippets


.PHONY: phpstan
phpstan: phpstan-sources phpstan-tests

.PHONY: phpstan-sources
phpstan-sources:
	 ./vendor/bin/phpstan --configuration=./.phpstan-sources.neon

.PHONY: phpstan-tests
phpstan-tests:
	 ./vendor/bin/phpstan --configuration=./.phpstan-tests.neon

.PHONY: phpstan-update-sources-baseline
phpstan-update-sources-baseline:
	 ./vendor/bin/phpstan --configuration=./.phpstan-sources.neon --generate-baseline=./tests/PHPStan/.phpstan-sources-baseline.neon

.PHONY: phpstan-update-tests-baseline
phpstan-update-tests-baseline:
	 ./vendor/bin/phpstan --configuration=./.phpstan-tests.neon --generate-baseline=./tests/PHPStan/.phpstan-tests-baseline.neon

.PHONY: codestyle
codestyle: create-build-directories
	./vendor/bin/phpcs ${PHPCS_DISABLE_WARNING_OPTION} --standard=phpcs.xml.dist ${PHPCS_COLOR_OPTION} ${PHPCS_REPORT_FILE_OPTION} --report=${PHPCS_REPORT_STYLE}

.PHONY: codestyle-fix
codestyle-fix:
	./vendor/bin/phpcbf

# Internal commands
.PHONY: create-build-directories
create-build-directories:
	mkdir -p ${PHPUNIT_COVERAGE_DIRECTORY} ${BEHAT_COVERAGE_DIRECTORY} ${REPORTS_DIRECTORY}
