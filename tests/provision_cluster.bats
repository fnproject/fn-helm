load test_helper

@test "create cluster" {
    run helm install fn --name testcluster-simple --wait --timeout 120s
    [ $status -eq 0 ]
    run helm test testcluster-simple
    [ $status -eq 0 ]
}