#! /usr/bin/env python2

import subprocess
import os
import argparse

root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
tests_dir = os.path.join(root_dir, 'tests')
bin_dir = os.path.join(tests_dir, "bin")
obj_dir = os.path.join(tests_dir, "obj")
cov_dir = os.path.join(tests_dir, "coverage_results")
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

    if p.returncode:
        print "Cmd: " + " ".join(argv)
        print "=== stdout ===\n" + stdout
        print "=== stderr ===\n" + stderr
    return (p.returncode, stdout, stderr)

at_lease_one_error = False


def print_result(name, error):
    if error:
        at_lease_one_error = True
        print('\x1b[31mFAIL\x1b[0m {}: {}'.format(error, name))
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


def gcda_files():
    l = []
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".gcda"):
                l.append(os.path.join(root, file))
    return l


def coverage_analysis():

    files = gcda_files()

    if not os.path.exists(cov_dir):
        os.makedirs(cov_dir)

    print "Coverage analysis (%d files)..." % len(files)
    os.chdir(cov_dir)
    run_program(*(['gcov'] + files))

    lcov_file = os.path.join(cov_dir, 'coverage.info')

    run_program('lcov', '--directory', obj_dir, '--initial',
                '--capture', '--output-file', lcov_file)

    run_program('lcov', '--directory', obj_dir,
                '--capture', '--output-file', lcov_file)

    for filt in ['*/adainclude/*', '*/tests/*']:
        run_program('lcov', '--remove', lcov_file, filt,
                    '--output-file', lcov_file)

    ret, stdout, stderr = run_program('lcov', '-l', lcov_file)
    print stdout

    run_program('genhtml', '--ignore-errors', 'source', lcov_file,
                '--output-directory=' + os.path.join(cov_dir, 'html'))


def main(args):

    # Clean tests
    ret, stdout, stderr = run_program("gprclean", "-r", "-P",
                                      os.path.join(tests_dir, "tests.gpr"))
    print_result("Test cleanup", ret)

    build_args = ["gprbuild", '-p', '-f', "-j0", "-P",
                  os.path.join(tests_dir, "tests.gpr")]

    if args.coverage:
        build_args += ['-g', '-largs', '-lgcov', '-fprofile-arcs',
                       '-cargs', '-fprofile-arcs', '-ftest-coverage']
    # Build tests
    ret, stdout, stderr = run_program(*build_args)
    print_result("Test build", ret)

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

        print_result("Test " + test, ret)

    if args.coverage:
        coverage_analysis()

    if at_least_one_error:
        sys.exit(1)


parser = argparse.ArgumentParser('Run the testsuite')

parser.add_argument(
    '--coverage', action='store_true', default=False,
    help='Compute code coverage'
)

parser.add_argument(
    '--verbose', action='store_true',
    help='Print exit code and output for all tests, regardless of results'
)

if __name__ == '__main__':
    main(parser.parse_args())
