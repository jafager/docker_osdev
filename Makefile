build:
	docker build -t osdev -f Dockerfile .
	docker volume rm -f osdev

run:
	docker run -it --rm --mount source=osdev,target=/home/osdev -p 5900:5900 osdev
