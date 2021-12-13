// Load a json file and print the results

import path from "path";
import jsonfile from "jsonfile";
const __dirname = path.resolve();

export function mapKeys(jsonz, acc = 0, tot = 0) {
  const loopKeys = ["enjoys_job", "respected_by_managers", "good_for_carers"];

  loopKeys.forEach(key => {
    if (jsonz[key] === "yes") {
      acc++;
    }
    if (jsonz[key] != "yes" || "not") {
      tot++;
    }
  });
  return {
    acc: acc,
    tot: tot,
  };
}

function exceed_hours(jsonz, acc) {
  if (Math.abs(jsonz.contracted_hours - jsonz.hours_actually_worked) <= 8) {
    acc++;
  }
  return {
    acc: acc,
  };
}

function unpaid_extra(jsonz, acc, tot) {
  if (jsonz.unpaid_extra_work === "no") {
    acc++;
  }
  if (jsonz.unpaid_extra_work != "yes" || "not") {
    tot++;
  }
  return {
    acc: acc,
    tot: tot,
  };
}

// Add 1 to accumulator if hourly_rate is higher than 8.91
function check_wage(jsonz, acc, tot) {
  const money = parseFloat(jsonz.hourly_rate.replace("£", ""));
  if (money >= 8.21) {
    acc++;
  }
  if (money <= 8.21 || jsonz.hourly_rate != "") {
    tot++;
  }
  return {
    acc: acc,
    tot: tot,
  };
}

// calculate percentage between accumulator and total
function percentage(accumulator, total) {
  return accumulator / total * 100;
}

const print_results = (acc, tot) => {
  // eslint-disable-next-line no-console
  console.log(
    "Score is %d/%d (%d%)",
    acc,
    tot,
    Math.trunc(percentage(acc, tot))
  );
  console.log(acc);
};

const score = jsonz => {
  let acc = 0;
  let tot = 0;
  mapKeys(jsonz);
  exceed_hours(jsonz, acc, tot);
  unpaid_extra(jsonz, acc, tot);
  check_wage(jsonz, acc, tot);
  print_results(acc, tot);
};

if (process.argv[2]) {
  let file = process.argv[2];
  let file_path = path.join(__dirname, file);
  let json = jsonfile.readFileSync(file_path);
  score(json);
} else {
  // eslint-disable-next-line no-console
  console.log("Please provide a json file as an argument");
}
