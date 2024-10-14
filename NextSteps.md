### So what were my next steps for the automated grading application…

#### - Needs to be refactored. Not really but I’d recommend it. If I were to rewrite it: 
    -	Build on top of the current code, but not use it. The automated_marking_tool is the original version but whatever you create, i’d start it in the gradingbot folder. This is a clean flutter project. By all means use the code, from the automated_marking_tool but really take a look at which bits are redundant and could be improved.
    -	I’d make it more modular. Separate functions into constituent components, same with UI/Layout, I’d create widgets for each piece of the layout. This goes for different packages as well…things like database access or model prompting could be made more abstract. Means you could implement the usage of different LLM models like Claude and allow the user to select.

#### Steps:
    -	Start by moving the login and registration system across. For the most part, this section is still intact and functional. You’ll need to recreate the firebase project and add it to the flutter project using flutterfire. Or implement your own database solution. (In the case of firebase, you can access the local environment variable in the /assets/.env.local which will ensure firebase API keys are not leaked upon github upload)
    -	Then look at the landing screen (currently a carousel but not really necessary unless you want to change) – could add feature so instead of just a chat screen, it is instead a page in which the teacher/lecturer can ask questions about the marking of that persons work. For examples of each of the criteria and whatnot.
    -	Then look into how you want to approach the rest of it. The essay screens…

Sidenote: Whoever builds this project will need access to a the OpenAI API Dashboard to ensure they have enough credits to run this. However, this is more accessible than ever with the release of models like 4o or 4o-mini. The release of batch completions is an incredible addition that could be utilised immensely with essay/test marking – lowering cost per essay substantially.
