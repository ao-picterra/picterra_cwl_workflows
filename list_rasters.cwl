#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: List of rasters IDs (of the authenticated user) optionally in a folder
doc: The picterra CLI call needs to return a valid JSON
baseCommand: [python3, -m, picterra, list, rasters]
requirements:
  EnvVarRequirement:
    envDef:
      PICTERRA_API_KEY: $(inputs.api_key)
      PICTERRA_BASE_URL: $(inputs.api_server)
  InlineJavascriptRequirement: {}
inputs:
  api_key: string
  api_server: string
  folder_id:
    type: string?
    inputBinding:
      position: 1
      prefix: --folder
# We redirect the output of the command (a JSON strin) to this temporary file
# https://www.commonwl.org/v1.0/CommandLineTool.html#CommandLineTool
stdout: out.json
outputs:
  rasters_ids_list:
    type:
      type: array
      items: string
    outputBinding:
      loadContents: true
      glob: "out.json"
      outputEval: |
        ${
          var res = JSON.parse(self[0].contents).map(e => e.id)
          console.log(res);
          return res;
        }