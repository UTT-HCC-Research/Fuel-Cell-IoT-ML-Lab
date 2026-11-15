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
