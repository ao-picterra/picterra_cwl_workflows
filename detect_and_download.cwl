#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [python3, -m, picterra, detect]
requirements:
  EnvVarRequirement:
    envDef:
      PICTERRA_API_KEY: $(inputs.api_key)
      PICTERRA_BASE_URL: $(inputs.api_server)
  # https://www.commonwl.org/user_guide/15-staging/
  InitialWorkDirRequirement:
    listing:
      - $(inputs.output_file)
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
  output_file:
    type: File
    inputBinding:
      position: 3
      prefix: --output-file
outputs:
  result_file:
    type: File
    outputBinding:
      glob:  "*.geojson"