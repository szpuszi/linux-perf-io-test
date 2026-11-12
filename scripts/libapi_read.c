#include <api/fs/fs.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(void)
{
	static const char expected[] = "\xc3\xa9\xff\n";
	char path[] = "/tmp/libapi-io-XXXXXX";
	char *content = NULL;
	size_t length = 0;
	int fd, result, failed;

	fd = mkstemp(path);
	if (fd < 0)
		return 2;
	if (write(fd, expected, sizeof(expected) - 1) != (ssize_t)(sizeof(expected) - 1)) {
		close(fd);
		unlink(path);
		return 2;
	}
	close(fd);
	result = filename__read_str(path, &content, &length);
	unlink(path);
	printf("status=%d length=%zu expected=%zu\n",
	       result, length, sizeof(expected) - 1);
	failed = result || length != sizeof(expected) - 1;
	if (!failed)
		failed = memcmp(content, expected, sizeof(expected) - 1);
	free(content);
	return failed != 0;
}
