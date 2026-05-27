# NOTES

## Personal Notes

- It can be easy to fall into the "one more game" type of mentality because starting the prompt is easier than the verification at the end. Find good stopping points for a healthy balance.
- Workflow of telling the agent to create a TODO list then work through the items sequentially helped avoid spiraling, but not always. Instructions to work in small, discrete steps showed additional improvement, but still was no guarantee of consistent work process.
- Models were likely trained based on container workflow which were not specific to distroless images. This caused many failed attempts to use alternative ENTRYPOINT or RUN syntax which would rely upon `/bin/sh`. These commands fail in distroless images so we need to provide full explicit paths to the binaries which are present in order to make otherwise simple things work.

## Generated Notes

### Common Pitfalls and Solutions

- **Error: File not found when reading configuration files (e.g., `opencode.json`)**
  - **Solution:** Ensure the configuration file exists in the expected directory before attempting to read it.

- **Error: `bash` tool called with invalid arguments (SchemaError: Missing key `description`)**
  - **Solution:** Always provide a clear and concise description for every `bash` tool call to satisfy the schema requirements.

- **Error: `edit` tool failed due to multiple matches for `oldString`**
  - **Solution:** Provide more surrounding context within the `oldString` to make the target text unique within the file.

- **Error: `edit` tool failed because `oldString` could not be found**
  - **Solution:** Verify that the `oldString` exactly matches the content of the file, including whitespace, indentation, and line endings.

- **Error: `write` tool called with invalid arguments (SchemaError: Missing key `filePath`)**
  - **Solution:** Ensure every `write` tool call includes the ``filePath` parameter.

- **Error: `todowrite` or `question` tool called with invalid arguments (SchemaError: Expected array)**
  - **Solution:** Ensure that the arguments passed to `todowrite` and `question` are provided as an array of objects, following the expected schema.

- **Error: `edit` tool failed because `oldString` and `newString` are identical**
  - **Solution:** Review the change you are attempting to make; if the strings are identical, no modification will occur.

- **Error: The user rejected permission to use a specific tool call**
  - **Solution:** Respect the user's decision. If a tool is necessary, explain why and ask for permission again, or seek an alternative way to achieve the goal.
