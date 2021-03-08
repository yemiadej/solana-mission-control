package monitor

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/PrathyushaLakkireddy/solana-prometheus/config"
	"github.com/PrathyushaLakkireddy/solana-prometheus/types"
)

func GetBlockTime(slot int64, cfg *config.Config) (types.BlockTime, error) {
	var result types.BlockTime
	ops := types.HTTPOptions{
		Endpoint: cfg.Endpoints.RPCEndpoint,
		Method:   http.MethodPost,
		Body:     types.Payload{Jsonrpc: "2.0", Method: "getBlockTime", ID: 1, Params: []interface{}{slot}},
	}

	resp, err := HitHTTPTarget(ops)
	if err != nil {
		log.Printf("Error while getting block time: %v", err)
		return result, err
	}

	err = json.Unmarshal(resp.Body, &result)
	if err != nil {
		log.Printf("Error while unmarshelling block time res: %v", err)
		return result, err
	}
	fmt.Println("///////////////////result from getblock time ")
	fmt.Println(result.Result)
	return result, nil
}
