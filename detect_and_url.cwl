#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [python3, -m, picterra, detect]
requirements:
  EnvVarRequirement:
    envDef:
      PICTERRA_API_KEY: $(inputs.api_key)
      PICTERRA_BASE_URL: $(inputs.api_server)
stdout: result_url.txt
inputs:
  api_key: string
  api_server: string
  raster:
    type: string
    inputBinding:
      position: 1
  detector:
    type: string
    inputBinding:
      position: 2
outputs:
  example_out:
    type: stdout