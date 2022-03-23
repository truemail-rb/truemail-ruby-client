# Development environment guide

## Preparing

Clone `truemail-ruby-client` repository:

```bash
git clone https://github.com/truemail-rb/truemail-ruby-client.git
cd  truemail-ruby-client
```

Configure latest Ruby environment:

```bash
echo 'ruby-3.1.1' > .ruby-version
cp .circleci/gemspec_latest truemail-client.gemspec
```

## Installing dependencies

```bash
bundle install
```

## Commiting

Commit your changes excluding `.ruby-version`, `truemail-client.gemspec`

```bash
git add . ':!.ruby-version' ':!truemail-client.gemspec'
git commit -m 'Your new awesome truemail-client feature'
```
