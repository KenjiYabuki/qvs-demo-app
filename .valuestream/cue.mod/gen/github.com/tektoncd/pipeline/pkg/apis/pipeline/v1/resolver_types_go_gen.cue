// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/tektoncd/pipeline/pkg/apis/pipeline/v1

package v1

// ResolverName is the name of a resolver from which a resource can be
// requested.
#ResolverName: string

// ResolverRef can be used to refer to a Pipeline or Task in a remote
// location like a git repo. This feature is in beta and these fields
// are only available when the beta feature gate is enabled.
#ResolverRef: {
	// Resolver is the name of the resolver that should perform
	// resolution of the referenced Tekton resource, such as "git".
	// +optional
	resolver?: #ResolverName @go(Resolver)

	// Params contains the parameters used to identify the
	// referenced Tekton resource. Example entries might include
	// "repo" or "path" but the set of params ultimately depends on
	// the chosen resolver.
	// +optional
	// +listType=atomic
	params?: [...#Param] @go(Params,[]Param)
}
