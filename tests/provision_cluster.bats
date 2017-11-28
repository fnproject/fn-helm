load test_helper

@test "create cluster" {
    run helm install fn --name testcluster-simple --wait --timeout 300
    echo "output = ${output}"
    [ $status -eq 0 ]
    run helm test testcluster-simple --cleanup
    [ $status -eq 0 ]
}



@test "create two clusters" {
    run helm install fn --name testcluster-first --wait --timeout 300
    echo "output = ${output}"
    [ $status -eq 0 ]
    run helm install fn --name testcluster-second --wait --timeout 300
    echo "output = ${output}"
    [ $status -eq 0 ]
    run helm test testcluster-first --cleanup
    echo "output = ${output}"
    [ $status -eq 0 ]
    run helm test testcluster-second --cleanup
    echo "output = ${output}"
    [ $status -eq 0 ]
}