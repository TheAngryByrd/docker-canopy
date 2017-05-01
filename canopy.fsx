#r "./packages/Selenium.WebDriver/lib/net40/WebDriver.dll"
#r "./packages/canopy/lib/canopy.dll"

open canopy
open runner
open OpenQA.Selenium

// Need to use --no-sandbox or chrome wont start
// https://github.com/elgalu/docker-selenium#chrome-not-reachable-or-timeout-after-60-secs
let chromeOptions = Chrome.ChromeOptions()
chromeOptions.AddArgument("--no-sandbox")
let chromeNoSandbox = ChromeWithOptions(chromeOptions)
start chromeNoSandbox

"Should check home page h1" &&& fun _ ->
  url "https://stackoverflow.com/"

  "h1#h-top-questions" == "Top Questions"

"Should check questions page h1" &&& fun _ ->
  url "https://stackoverflow.com/questions"

  "h1#h-all-questions" == "All Questions"

run()

quit()