# ThingSpeak TalkBack for a simulated fuel cell load

**Jake Cummings · November 10, 2026 · Version 1.0**  
**Internal draft for review before publication**

This lesson extends the ThingSpeak monitoring activity in *Learn PEMFC through Data*. In the existing activity, MATLAB sends measurements to ThingSpeak. Here, MATLAB requests commands from a ThingSpeak TalkBack queue and applies them to a simulated electronic-load setpoint for a proton exchange membrane fuel cell (PEMFC). The simulation runs in MATLAB R2026b with no connected instruments or additional toolboxes.

**Contribution credit.** Jake Cummings developed the MATLAB/ThingSpeak TalkBack integration and current-sweep routine for the PEMFC test bench on October 15, 2026, and prepared this teaching exercise. The exercise uses example commands and simulated setpoints.

## Learning objectives

- Explain how a command queue complements a ThingSpeak measurement channel.
- Retrieve one command per request and apply only commands on the lesson's allowlist.
- Distinguish a queued command, a retrieved command, and the resulting change in simulated current.

## How TalkBack fits into the workflow

A ThingSpeak channel stores measurements sent by MATLAB. A TalkBack app holds commands that a client can retrieve when it is ready. In this exercise, the user adds a command in the ThingSpeak web interface, MATLAB retrieves it, and the MATLAB function updates a simulated current setpoint.

| Operation | Result |
| --- | --- |
| Add a command in ThingSpeak | ThingSpeak stores the command in the queue. Commands added without an explicit position go to the end. |
| Request the next command with Execute TalkBack Command | ThingSpeak returns and removes the next command. The JavaScript Object Notation (JSON) response is an empty object when the queue is empty. |
| Apply the command in MATLAB | MATLAB checks the command against the allowlist and records the simulated setpoint and outcome. |

ThingSpeak's execution timestamp records retrieval from the queue. The MATLAB results table records how the client handled the command. Use both records when tracing an action in connected mode. [MathWorks Add TalkBack Command](https://www.mathworks.com/help/thingspeak/addtalkbackcommand.html) · [MathWorks Execute TalkBack Command](https://www.mathworks.com/help/thingspeak/executetalkbackcommand.html)

## 1. Run the offline exercise

Copy the MATLAB example into a file named `talkback_simulated_load.m` in the current MATLAB folder. Run `results = talkback_simulated_load()`. The example starts at zero current and reads five simulated queue responses. The lesson command strings are case-insensitive, and MATLAB trims leading and trailing spaces before checking them.

| Poll | Queue response | MATLAB outcome | Simulated current (A) |
| --- | --- | --- | ---: |
| 1 | `SET_LOW` | Applied | 0.25 |
| 2 | `UNRECOGNIZED` | Rejected. Holds the previous setpoint. | 0.25 |
| 3 | `SET_HIGH` | Applied | 0.75 |
| 4 | `STOP` | Sets the simulated current to zero. | 0.00 |
| 5 | Empty queue | Holds the previous setpoint. | 0.00 |

An ampere (A) is the unit of electric current. These setpoints are exercise values. Keep both versions of the activity connected only to the simulator.

## 2. Retrieve commands from a ThingSpeak test queue

1. Sign in to ThingSpeak and create a dedicated queue under **Apps → TalkBack → New TalkBack**. Use a queue reserved for this exercise and keep it separate from any physical controller. Select a channel only if you want the optional **Logged to Channel** feature, which records retrieved commands in the channel's **Status** field. [MathWorks TalkBack app setup](https://www.mathworks.com/help/thingspeak/talkback-app.html)
2. Run `setSecret("PEMFC_TEACHING_TALKBACK_KEY")` in the MATLAB Command Window. Enter the dedicated queue's application programming interface (API) key in the prompt. Keep the key in the MATLAB vault and omit it from source files, screenshots, and shared outputs. [MathWorks MATLAB vault setup](https://www.mathworks.com/help/matlab/ref/setsecret.html)
3. In the empty test queue, add `SET_LOW`, `UNRECOGNIZED`, `SET_HIGH`, and `STOP` in that order. Leave the command position blank to append each command.
4. Call the function with your numeric TalkBack identifier (ID). For example, run `results = talkback_simulated_load(12345)` with `12345` replaced by the test queue's ID. The function makes up to five requests. Compare the results with the offline table and verify that the four commands disappear from the queue.
5. Requeue the four commands before repeating the exercise. If the function reports `request failed`, first check the ID, vault entry, network connection, and queue or last-command record. A request can time out after ThingSpeak has already removed the command. Check the queue state before re-adding anything. [MathWorks Get Last Executed Command](https://www.mathworks.com/help/thingspeak/getlastexecutedtalkbackcommand.html)

## MATLAB example

```matlab
function results = talkback_simulated_load(talkbackID)
% Jake Cummings | November 10, 2026
% Process TalkBack commands using a simulated electronic-load setpoint.

    useThingSpeak = nargin == 1;
    sampleCommands = ["SET_LOW"; "UNRECOGNIZED"; "SET_HIGH"; "STOP"; ""];
    numPolls = numel(sampleCommands);

    if useThingSpeak
        validateattributes(talkbackID, {'numeric'}, ...
            {'scalar', 'real', 'finite', 'integer', 'positive'});
        talkbackKey = getSecret("PEMFC_TEACHING_TALKBACK_KEY");
        endpoint = sprintf( ...
            'https://api.thingspeak.com/talkbacks/%d/commands/execute.json', ...
            talkbackID);
        options = weboptions("ContentType", "json", "Timeout", 10);
    end

    currentA = 0;
    received = strings(numPolls, 1);
    outcome = strings(numPolls, 1);
    simulatedCurrentA = zeros(numPolls, 1);

    for poll = 1:numPolls
        command = sampleCommands(poll);

        if useThingSpeak
            try
                response = webwrite(endpoint, "api_key", talkbackKey, options);
                if isequal(response, struct())
                    command = "";
                else
                    command = string(response.command_string);
                    if ~isscalar(command) || ismissing(command)
                        error("Invalid TalkBack command response.");
                    end
                end
            catch
                received(poll) = "<unavailable>";
                outcome(poll) = "request failed";
                simulatedCurrentA(poll) = 0;
                break
            end
        end

        command = upper(strtrim(command));
        received(poll) = command;

        switch command
            case "SET_LOW"
                currentA = 0.25;
                outcome(poll) = "applied";
            case "SET_HIGH"
                currentA = 0.75;
                outcome(poll) = "applied";
            case "STOP"
                currentA = 0;
                outcome(poll) = "stopped";
            case ""
                outcome(poll) = "empty queue";
            otherwise
                outcome(poll) = "rejected";
        end

        simulatedCurrentA(poll) = currentA;

        if useThingSpeak && poll < numPolls
            pause(2);
        end
    end

    rows = (1:poll).';
    results = table(rows, received(rows), outcome(rows), ...
        simulatedCurrentA(rows), 'VariableNames', ...
        {'Poll', 'Command', 'Outcome', 'SimulatedCurrent_A'});
end
```

The connected example sends a form-encoded request using `webwrite` and reads the JSON response. On a failed request or malformed response, the exercise logs zero simulated current and ends the run. [MathWorks `webwrite` reference](https://www.mathworks.com/help/matlab/ref/webwrite.html)

## Check your understanding

1. Explain why `UNRECOGNIZED` disappears from the ThingSpeak queue even though MATLAB rejects it.
2. Move the offline empty response immediately after `SET_HIGH`. Predict the current on that row, rerun the example, and compare it with the `STOP` response.
3. Explain why a queued `STOP` can arrive late if commands are ahead of it or MATLAB loses its connection. Identify which record would show that MATLAB actually processed it.

