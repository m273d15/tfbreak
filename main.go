package main

import (
	"os"

	"github.com/fatih/color"
	"github.com/jessevdk/go-flags"
	"github.com/m273d15/tfbreak/pkg/tfbreak"
)


type TfBreakOpts struct {
	OldSrcVersion  string   `short:"o" long:"old-src" description:"Old hcl2 code path." required:"true"`
	NewSrcVersion  string   `short:"n" long:"new-src" description:"New hcl2 code path." required:"true"`
	WorkDir        *string  `long:"workdir" description:"Workdir used to copy the source to (default: '$PWD/.temp_hcl2diff')" required:"false"`
	DepreactionMarker string   `long:"deprecation-marker" default:"[Deprecated]" description:"Text in a variable/output description that highlights a deprecation." required:"false"`
}

func main() {
	var opts TfBreakOpts
	_, err := flags.Parse(&opts)
	if err != nil {
		os.Exit(1)
	}

  result := tfbreak.CheckTerraformChanges(opts.OldSrcVersion, opts.NewSrcVersion, opts.WorkDir, opts.DepreactionMarker)

  breakCLog := color.New(color.FgRed, color.Bold)
  depCLog := color.New(color.FgYellow, color.Bold)

  for _, depMsg := range result.DeprecationMessages {
    depCLog.Printf("Deprecation: %s\n", depMsg)
  }
  for _, depMsg := range result.BreakingChangeMessages {
    breakCLog.Printf("Breaking Change: %s\n", depMsg)
  }
}
