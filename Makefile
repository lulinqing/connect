
TESTS = test/*.js
REPORTER = tap
DOX = ./node_modules/.bin/dox

SRC = $(shell find lib/*.js lib/middleware/*.js)
HTML = $(SRC:.js=.html)

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		--timeout 600 \
		--bail \
		$(TESTS)

docs: $(HTML)
	@mv $(HTML) docs

test-cov: lib-cov
	@CONNECT_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html

lib-cov:
	@jscoverage lib $@

%.html: %.js
	$(DOX) < $< | node support/docs > $@

docclean:
	rm -f $(HTML)

site: docclean docs
	rm -fr /tmp/docs \
		&& cp -fr docs /tmp/docs \
	  && git checkout gh-pages \
	  && cp -fr /tmp/docs/* . \
	  && echo "done"

benchmark:
	@./support/bench

.PHONY: test-cov site docs test docclean benchmark
