#!/bin/bash
set -e
#Note: -e makes the script fail if any subcommand fails (i.e. return code != 0)
# --> our tests need to return a failure code if something is wrong
script_dir="$( cd "$(dirname "$0")" ; pwd -P )"

#parameters
n_proc_default=4
m_proc_default=4

function run_test {
	exec_name=$1
	n_proc=${n_proc_default}
	m_proc=${m_proc_default}
	if [ -n "$2" ]; then
		n_proc=$2
	fi
	if [ -n "$3" ]; then
		m_proc=$3
	fi
	total_proc=`expr $n_proc \* $m_proc`
	echo "Running ${exec_name} on ${n_proc} x ${m_proc} processes"
	rm -f ${script_dir}/output/*
	srun -n ${total_proc} --ntasks-per-node=12 -c 1 ${script_dir}/${exec_name} -n ${n_proc} -m ${m_proc} -s test.ini
	echo
	for test_file in ${script_dir}/output/test_pk*
	do
		test_file2=`basename $test_file`
		echo "Checking ${test_file2}"
		cmp -s ${test_file} ${script_dir}/ref/${test_file2}
	done
}

#run tests
run_test gevolution_cpu 2 2
#run_test gevolution_gpu 2 2

echo "All tests passed"
