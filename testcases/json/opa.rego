package test

# Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
notAllowedSeverities := ["Critical", "High", "UnknownSeverity"]
ignoreCves := []

contains(array, elem) = true {
  array[_] = elem
} else = false { true }

isSafe(match) {
  severities := { e | e := match.ratings.rating.severity } | { e | e := match.ratings.rating[_].severity }
  some i
  fails := contains(notAllowedSeverities, severities[i])
  not fails
}

isSafe(match) {
  ignore := contains(ignoreCves, match.id)
  ignore
}

deny[msg] {
  comps := { e | e := input.bom.components.component } | { e | e := input.bom.components.component[_] }
  some i
  comp := comps[i]
  vulns := { e | e := comp.vulnerabilities.vulnerability } | { e | e := comp.vulnerabilities.vulnerability[_] }
  some j
  vuln := vulns[j]
  ratings := { e | e := vuln.ratings.rating.severity } | { e | e := vuln.ratings.rating[_].severity }
  not isSafe(vuln)
  msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
}