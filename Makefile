include make-compose.mk
include make-ansible.mk

clean:
	rm -rf services/app/tmp/
	rm -rf services/app/log/
