#! /usr/bin/env python2

import subprocess
import os

root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
tests_dir = os.path.join(root_dir, 'tests')
bin_dir = os.path.join(tests_dir, "bin")
expect_dir = os.path.join(tests_dir, "expected_outputs")


def run_program(*argv):
    p = subprocess.Popen(
        argv,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    stdout, stderr = p.communicate()

    try:
        stdout = stdout.decode('ascii')
    except UnicodeError:
        return 'stdout is not ASCII'

    try:
        stderr = stderr.decode('ascii')
    except UnicodeError:
        return 'stderr is not ASCII'

    return (p.returncode, stdout, stderr)

at_lease_one_error = False


def print_result(name, error, stdout, stderr):
    if error:
        at_lease_one_error = True
        print('\x1b[31mFAIL\x1b[0m {}: {}\nstdout:\n{}\n stderr:\n{}'.format(error, name, stdout, stderr))
    else:
        print('\x1b[32mOK\x1b[0m     : {}'.format(name))


def to_file(filename, data):
    with open(filename, "w") as file:
        file.write(data)


def diff(A, B):
    ret, stdout, stderr = run_program("diff", "-u", A, B)
    return (ret, stdout, stderr)


def find_testcases():
    for filename in os.listdir(bin_dir):
        if os.path.isfile(os.path.join(bin_dir, filename)) and \
           os.access(os.path.join(bin_dir, filename), os.X_OK):
            yield filename


def main():

    # Clean tests
    ret, stdout, stderr = run_program("gprclean", "-r", "-P",
                                      os.path.join(tests_dir, "tests.gpr"))
    print_result("Test cleanup", ret, stdout, stderr)

    # Build tests
    ret, stdout, stderr = run_program("gprbuild", "-j0", "-P",
                                      os.path.join(tests_dir, "tests.gpr"))
    print_result("Test build", ret, stdout, stderr)

    at_least_one_error = False

    for test in find_testcases():
        bin = os.path.join(bin_dir, test)
        expected = os.path.join(expect_dir, test + ".out")
        ret, stdout, stderr = run_program(bin)

        to_file(bin + ".out", stdout)

        diff_ret, diff_out, diff_err = diff(expected, bin + ".out")

        if diff_ret:
            ret = diff_ret
            stdout = diff_out
            stderr = diff_err

        print_result("Test " + test, ret, stdout, stderr)

    if at_least_one_error:
        sys.exit(1)


if __name__ == '__main__':
    main()
