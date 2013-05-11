/*
 *
 * ao_example.c
 *
 *     Written by Stan Seibert - July 2001
 *
 * Legal Terms:
 *
 *     This source file is released into the public domain.  It is
 *     distributed without any warranty; without even the implied
 *     warranty * of merchantability or fitness for a particular
 *     purpose.
 *
 * Function:
 *
 *     This program opens the default driver and plays a 440 Hz tone for
 *     one second.
 *
 * Compilation command line (for Linux systems):
 *
 *     gcc -lao -ldl -lm -o ao_example ao_example.c
 *
 */

#include <stdio.h>
#include <string.h>
#include <ao/ao.h>
#include <math.h>

#define BUF_SIZE 4096

int main(int argc, char **argv)
{
	ao_device *device;
	ao_sample_format format;
	int default_driver;
	char *buffer;
	int buf_size;
	int sample;
	float freq = 440.0;
	int v;
	int i;

	/* -- Initialize -- */

	fprintf(stderr, "libao example program\n");

	ao_initialize();

	/* -- Setup for default driver -- */

	default_driver = ao_default_driver_id();
	if (default_driver < 0) {
		fprintf(stderr, "Error getting default driver id\n");
		return 1;
	}

        memset(&format, 0, sizeof(format));
	format.bits = 16;
	format.channels = 2;
	format.rate = 44100;
	format.byte_format = AO_FMT_LITTLE;

	/* -- Open driver -- */
	device = ao_open_live(default_driver, &format, NULL /* no options */);
	if (device == NULL) {
		fprintf(stderr, "Error opening device. errno=%d\n", errno);
		return 1;
	}

	/* -- Play some stuff -- */
	buf_size = format.bits/8 * format.channels * format.rate;
	buffer = calloc(buf_size,
			sizeof(char));

	for (i = 0; i < format.rate; i++) {
		sample = (int)(0.75 * 32768.0 *
			sin(2 * M_PI * freq * ((float) i/format.rate)));

		/* Put the same stuff in left and right channel */
		buffer[4*i] = buffer[4*i+2] = sample & 0xff;
		buffer[4*i+1] = buffer[4*i+3] = (sample >> 8) & 0xff;
	}
	v = ao_play(device, buffer, buf_size);
	if (v == 0) {
		fprintf(stderr, "failure playing samples.\n");
		return 1;
	}

	/* -- Close and shutdown -- */
	v = ao_close(device);
	if (v == 0) {
		fprintf(stderr, "failure closing device.\n");
		return 1;
	}

	ao_shutdown();
	fprintf(stderr, "ao_example done\n");

  return (0);
}
