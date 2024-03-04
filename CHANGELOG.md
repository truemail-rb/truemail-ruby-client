# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.1] - 2024-03-04

### Added

- Added `commitspell`

### Updated

- Updated development dependencies
- Updated gemspecs
- Updated `codeclimate`/`circleci` configs
- Updated gem version

## [0.6.0] - 2023-02-06

### Added

- Added supporting of latest Ruby 3.3.0

### Updated

- Updated development dependencies
- Updated gemspecs
- Updated `codeclimate` config
- Updated gem version

## [0.5.2] - 2023-11-08

### Updated

- Updated development dependencies
- Updated gemspecs
- Updated `reek`/`codeclimate` configs
- Updated gem version

## [0.5.1] - 2023-08-14

### Updated

- Updated development dependencies
- Updated gemspecs
- Updated `rubocop`/`codeclimate`/`circleci` configs
- Updated gem version

## [0.5.0] - 2023-02-18

### Added

- Added supporting of latest Ruby 3.2.0
- Added new bunch of project linters
- Added auto deploy to RubyGems
- Added auto creating release notes on GitHub

### Updated

- Updated development dependencies
- Updated gemspecs
- Updated `rubocop`/`codeclimate`/`circleci` configs
- Updated gem version

### Removed

- Removed `overcommit` dependency

## [0.4.1] - 2022-03-23

### Added

- Development environment guide

### Changed

- Updated gemspecs
- Updated `rubocop`/`codeclimate`/`circleci` configs
- Updated gem version

## [0.4.0] - 2022-01-26

### Changed

- Updated gemspecs
- Updated `rubocop`/`codeclimate`/`simplecov`/`circleci` configs
- Updated gem version

## [0.3.4] - 2021-09-16

### Changed

- Updated gem dependencies
- Updated `rubocop`/`codeclimate` config
- Updated gem version

## [0.3.3] - 2021-07-13

### Fixed

- Security vulnerability [CVE-2021-32740](https://github.com/advisories/GHSA-jxhc-q857-3j6g)

### Changed

- Updated gem dependencies
- Updated `rubocop`/`codeclimate` config
- Updated gem version

## [0.3.2] - 2021-05-19

### Fixed

- Gem syntax compatibility with Ruby 3.x

### Changed

- Updated gem dependencies
- Updated `rubocop`/`codeclimate` config
- Updated gem version

## [0.3.1] - 2021-05-08

### Changed

- Updated gem dependencies
- Updated `rubocop`/`codeclimate` config
- Updated gem version

## [0.3.0] - 2020-10-28

### Changed

Truemail client sends encoded uri params, follows [RFC 3986, sec 2.1](https://tools.ietf.org/html/rfc3986#section-2.1).

- Updated `Truemail::Client::Http#request_uri`
- Updated gem dependencies
- Updated gem version, changelog, docs

## [0.2.1] - 2020-10-05

### Fixed

- Removed auth headers for public endpoint request

### Changed

- `Truemail::Client::Http#run`
- Updated gem version

## [0.2.0] - 2020-10-04

### Added

Ability to use Truemail healthcheck endpoint

- Added `Truemail::Client.server_healthy?`

### Changed

- Updated `Truemail::Client::Http#uri`
- Updated gem dependencies
- Updated gem documentation
- Updated gem version

## [0.1.1] - 2020-07-21

### Changed

- Updated gem dependencies
- Updated gem documentation
- Updated gem version

## [0.1.0] - 2020-03-29

### First release

- implemented first version of Truemail Ruby client
