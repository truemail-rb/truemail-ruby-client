# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.3] - 2021-07-13

### Fixed

- Security vulnerability [CVE-2021-32740](https://github.com/advisories/GHSA-jxhc-q857-3j6g)

### Changed

- Updated gem dependencies
- Updated rubocop/codeclimate config
- Updated gem version

## [0.3.2] - 2021-05-19

### Fixed

- Gem syntax compatibility with Ruby 3.x

### Changed

- Updated gem dependencies
- Updated rubocop/codeclimate config
- Updated gem version

## [0.3.1] - 2021-05-08

### Changed

- Updated gem dependencies
- Updated rubocop/codeclimate config
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
