load test_helper

@test "create cluster" {
    run helm install fn --name testcluster-simple --wait --timeout 300
    [ $status -eq 0 ]
    run helm test testcluster-simple --cleanup
    [ $status -eq 0 ]
}