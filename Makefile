include make-compose.mk
include make-ansible.mk
include make-production.mk

clean:
	rm -rf services/app/tmp/
	rm -rf services/app/public/assets/
	rm -rf services/app/log/
