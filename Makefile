s:
	rails s -b dope.local -p 3333

s!:
	sudo brew services restart nginx
	make s

db:
	rails db:migrate

db!:
	rails db:drop
	rails db:create
	rails db:migrate

restart:
	spring stop
	make s

console:
	rails c

test:
	rails test

c:
	rails c

routes:
	rails routes | grep -v 'rails\|turbo\|active_storage\|action_mailbox'

.PHONY: db test