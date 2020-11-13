#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [python3, -m, picterra, create, detector]
requirements:
  EnvVarRequirement:
    envDef:
      PICTERRA_API_KEY: $(inputs.api_key)
      PICTERRA_BASE_URL: $(inputs.api_server)
inputs:
  api_key: string
  api_server: string?
  name:
    type: string?
    inputBinding:
      position: 1
      prefix: --name
  detection_type:
    type: string?
    label: Type of detection
    inputBinding:
      position: 2
      prefix: --detection-type
  output_type:
    type: string?
    label: Type of output
    inputBinding:
      position: 3
      prefix: --output-type
  training_steps:
    type: int?
    label: Number of training steps (100-4000)
    inputBinding:
      position: 4
      prefix: --training-steps
    default: 1000
  rasters_ids:
    # https://www.commonwl.org/user_guide/09-array-inputs/index.html
    type: string[]?
    label: List of raster IDs
    inputBinding:
      separate: true
      position: 5
      prefix: -r
      itemSeparator: " "
stdout: output.txt
outputs:
  detector_id:
    type: string
    outputBinding:
       glob: output.txt
       loadContents: True
       outputEval: $(self[0].contents)