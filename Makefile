.PHONY = create send query browse

all: create send

create: 
	python2.6 create.py > out.xml

send:
	ruby send.rb

query:
	ruby query.rb

browse:
	sqlite3 sam/db/trac.db
