package tfbreak

import (
	"context"
	_ "embed"

	// TODO: Decide if this redundancy is fine
	"fmt"
	"log"
	"strings"

	"github.com/m273d15/hcl2diff/pkg/hcl2diff"
	"github.com/open-policy-agent/opa/rego"
)

const (
	deprecationRulePrefix    = "deprecate"
	breakingChangeRulePrefix = "break"
)

type Result struct {
  DeprecationMessages []string
  BreakingChangeMessages []string
}

//go:embed policy/breaking.rego
var module string

func opaResultsWithPrefix(results rego.ResultSet, prefix string) []string {
  var prefixedResults []string
	for key, msgs := range results[0].Expressions[0].Value.(map[string]interface{}) {
		if strings.HasPrefix(key, prefix) {
			for _, msg := range msgs.([]interface{}) {
	      if _, ok := msg.(string); ok {
          prefixedResults = append(prefixedResults, msg.(string))
        }
			}
		}
	}
  return prefixedResults
}


func CheckTerraformChanges(oldSrcVersion, newSrcVersion string, workdir *string, deprecationMarker string) Result {
  jsonPatch := hcl2diff.Hcl2DiffJsonWithGetter(oldSrcVersion, newSrcVersion, []string{".tf"}, workdir)
	config := fmt.Sprintf(`package config
  deprecation_marker := "%s"
  `, deprecationMarker)

	query, err := rego.New(
		rego.Query("data.main"),
		rego.Module("config.rego", config),
		rego.Module("breaking.rego", module),
	).PrepareForEval(context.Background())

	ctx := context.TODO()
	opaResults, err := query.Eval(ctx, rego.EvalInput(jsonPatch))

	if err != nil {
		// Handle error.
		log.Printf("Failed with %s\n", err.Error())
	}

  result := Result{}
  result.BreakingChangeMessages = opaResultsWithPrefix(opaResults, breakingChangeRulePrefix)
  result.DeprecationMessages = opaResultsWithPrefix(opaResults, deprecationRulePrefix)

  return result
}
