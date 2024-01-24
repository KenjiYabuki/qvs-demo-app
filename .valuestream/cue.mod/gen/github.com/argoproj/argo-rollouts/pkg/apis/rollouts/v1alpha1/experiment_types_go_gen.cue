// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/argoproj/argo-rollouts/pkg/apis/rollouts/v1alpha1

package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	corev1 "k8s.io/api/core/v1"
)

#ExperimentNameAnnotationKey:         "experiment.argoproj.io/name"
#ExperimentTemplateNameAnnotationKey: "experiment.argoproj.io/template-name"

// Experiment is a specification for an Experiment resource
// +genclient
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
// +kubebuilder:resource:path=experiments,shortName=exp
// +kubebuilder:printcolumn:name="Status",type="string",JSONPath=".status.phase",description="Experiment status"
// +kubebuilder:printcolumn:name="Age",type="date",JSONPath=".metadata.creationTimestamp",description="Time since resource was created"
#Experiment: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)
	spec:      #ExperimentSpec    @go(Spec) @protobuf(2,bytes,opt)
	status?:   #ExperimentStatus  @go(Status) @protobuf(3,bytes,opt)
}

// ExperimentSpec is the spec for a Experiment resource
#ExperimentSpec: {
	// Templates are a list of PodSpecs that define the ReplicaSets that should be run during an experiment.
	// +patchMergeKey=name
	// +patchStrategy=merge
	templates: [...#TemplateSpec] @go(Templates,[]TemplateSpec) @protobuf(1,bytes,rep)

	// Duration the amount of time for the experiment to run as a duration string (e.g. 30s, 5m, 1h).
	// If omitted, the experiment will run indefinitely, stopped either via termination, or a failed analysis run.
	// +optional
	duration?: #DurationString @go(Duration) @protobuf(2,bytes,opt,casttype=DurationString)

	// ProgressDeadlineSeconds The maximum time in seconds for a experiment to
	// make progress before it is considered to be failed. Argo Rollouts will
	// continue to process failed experiments and a condition with a
	// ProgressDeadlineExceeded reason will be surfaced in the experiment status.
	// Defaults to 600s.
	// +optional
	progressDeadlineSeconds?: null | int32 @go(ProgressDeadlineSeconds,*int32) @protobuf(3,varint,opt)

	// Terminate is used to prematurely stop the experiment
	terminate?: bool @go(Terminate) @protobuf(4,varint,opt)

	// Analyses references AnalysisTemplates to run during the experiment
	// +patchMergeKey=name
	// +patchStrategy=merge
	analyses?: [...#ExperimentAnalysisTemplateRef] @go(Analyses,[]ExperimentAnalysisTemplateRef) @protobuf(5,bytes,rep)

	// ScaleDownDelaySeconds adds a delay before scaling down the Experiment.
	// If omitted, the Experiment waits 30 seconds before scaling down.
	// A minimum of 30 seconds is recommended to ensure IP table propagation across the nodes in
	// a cluster. See https://github.com/argoproj/argo-rollouts/issues/19#issuecomment-476329960 for
	// more information
	// +optional
	scaleDownDelaySeconds?: null | int32 @go(ScaleDownDelaySeconds,*int32) @protobuf(6,varint,opt)

	// DryRun object contains the settings for running the analysis in Dry-Run mode
	// +patchMergeKey=metricName
	// +patchStrategy=merge
	// +optional
	dryRun?: [...#DryRun] @go(DryRun,[]DryRun) @protobuf(7,bytes,rep)

	// MeasurementRetention object contains the settings for retaining the number of measurements during the analysis
	// +patchMergeKey=metricName
	// +patchStrategy=merge
	// +optional
	measurementRetention?: [...#MeasurementRetention] @go(MeasurementRetention,[]MeasurementRetention) @protobuf(8,bytes,rep)
}

#TemplateSpec: {
	// Name of the template used to identity replicaset running for this experiment
	name: string @go(Name) @protobuf(1,bytes,opt)

	// Number of desired pods. This is a pointer to distinguish between explicit
	// zero and not specified. Defaults to 1.
	// +optional
	replicas?: null | int32 @go(Replicas,*int32) @protobuf(2,varint,opt)

	// Minimum number of seconds for which a newly created pod should be ready
	// without any of its container crashing, for it to be considered available.
	// Defaults to 0 (pod will be considered available as soon as it is ready)
	// +optional
	minReadySeconds?: int32 @go(MinReadySeconds) @protobuf(3,varint,opt)

	// Label selector for pods. Existing ReplicaSets whose pods are
	// selected by this will be the ones affected by this experiment.
	// It must match the pod template's labels. Each selector must be unique to the other selectors in the other templates
	selector?: null | metav1.#LabelSelector @go(Selector,*metav1.LabelSelector) @protobuf(4,bytes,opt)

	// Template describes the pods that will be created.
	template: corev1.#PodTemplateSpec @go(Template) @protobuf(5,bytes,opt)

	// TemplateService describes how a service should be generated for template
	service?: null | #TemplateService @go(Service,*TemplateService) @protobuf(6,bytes,opt)
}

#TemplateService: {
}

#TemplateStatusCode: string // #enumTemplateStatusCode

#enumTemplateStatusCode:
	#TemplateStatusProgressing |
	#TemplateStatusRunning |
	#TemplateStatusSuccessful |
	#TemplateStatusFailed |
	#TemplateStatusError

#TemplateStatusProgressing: #TemplateStatusCode & "Progressing"
#TemplateStatusRunning:     #TemplateStatusCode & "Running"
#TemplateStatusSuccessful:  #TemplateStatusCode & "Successful"
#TemplateStatusFailed:      #TemplateStatusCode & "Failed"
#TemplateStatusError:       #TemplateStatusCode & "Error"

// TemplateStatus is the status of a specific template of an Experiment
#TemplateStatus: {
	// Name of the template used to identity which hash to compare to the hash
	name: string @go(Name) @protobuf(1,bytes,opt)

	// Total number of non-terminated pods targeted by this experiment (their labels match the selector).
	replicas: int32 @go(Replicas) @protobuf(2,varint,opt)

	// Total number of non-terminated pods targeted by this experiment that have the desired template spec.
	updatedReplicas: int32 @go(UpdatedReplicas) @protobuf(3,varint,opt)

	// Total number of ready pods targeted by this experiment.
	readyReplicas: int32 @go(ReadyReplicas) @protobuf(4,varint,opt)

	// Total number of available pods (ready for at least minReadySeconds) targeted by this experiment.
	availableReplicas: int32 @go(AvailableReplicas) @protobuf(5,varint,opt)

	// CollisionCount count of hash collisions for the Experiment. The Experiment controller uses this
	// field as a collision avoidance mechanism when it needs to create the name for the
	// newest ReplicaSet.
	// +optional
	collisionCount?: null | int32 @go(CollisionCount,*int32) @protobuf(6,varint,opt)

	// Phase is the status of the ReplicaSet associated with the template
	status?: #TemplateStatusCode @go(Status) @protobuf(7,bytes,opt,casttype=TemplateStatusCode)

	// Message is a message explaining the current status
	message?: string @go(Message) @protobuf(8,bytes,opt)

	// LastTransitionTime is the last time the replicaset transitioned, which resets the countdown
	// on the ProgressDeadlineSeconds check.
	lastTransitionTime?: null | metav1.#Time @go(LastTransitionTime,*metav1.Time) @protobuf(9,bytes,opt)

	// ServiceName is the name of the service which corresponds to this experiment
	serviceName?: string @go(ServiceName) @protobuf(10,bytes,opt)

	// PodTemplateHash is the value of the Replicas' PodTemplateHash
	podTemplateHash?: string @go(PodTemplateHash) @protobuf(11,bytes,opt)
}

// ExperimentStatus is the status for a Experiment resource
#ExperimentStatus: {
	// Phase is the status of the experiment. Takes into consideration ReplicaSet degradations and
	// AnalysisRun statuses
	phase?: #AnalysisPhase @go(Phase) @protobuf(1,bytes,opt,casttype=AnalysisPhase)

	// Message is an explanation for the current status
	// +optional
	message?: string @go(Message) @protobuf(2,bytes,opt)

	// TemplateStatuses holds the ReplicaSet related statuses for individual templates
	// +optional
	templateStatuses?: [...#TemplateStatus] @go(TemplateStatuses,[]TemplateStatus) @protobuf(3,bytes,rep)

	// AvailableAt the time when all the templates become healthy and the experiment should start tracking the time to
	// run for the duration of specificed in the spec.
	// +optional
	availableAt?: null | metav1.#Time @go(AvailableAt,*metav1.Time) @protobuf(4,bytes,opt)

	// Conditions a list of conditions a experiment can have.
	// +optional
	conditions?: [...#ExperimentCondition] @go(Conditions,[]ExperimentCondition) @protobuf(5,bytes,rep)

	// AnalysisRuns tracks the status of AnalysisRuns associated with this Experiment
	// +optional
	analysisRuns?: [...#ExperimentAnalysisRunStatus] @go(AnalysisRuns,[]ExperimentAnalysisRunStatus) @protobuf(6,bytes,rep)
}

// ExperimentConditionType defines the conditions of Experiment
#ExperimentConditionType: string // #enumExperimentConditionType

#enumExperimentConditionType:
	#InvalidExperimentSpec |
	#ExperimentCompleted |
	#ExperimentProgressing |
	#ExperimentRunning |
	#ExperimentReplicaFailure

// InvalidExperimentSpec means the experiment has an invalid spec and will not progress until
// the spec is fixed.
#InvalidExperimentSpec: #ExperimentConditionType & "InvalidSpec"

// ExperimentCompleted means the experiment is available, ie. the active service is pointing at a
// replicaset with the required replicas up and running for at least minReadySeconds.
#ExperimentCompleted: #ExperimentConditionType & "Completed"

// ExperimentProgressing means the experiment is progressing. Progress for a experiment is
// considered when a new replica set is created or adopted, when pods scale
// up or old pods scale down, or when the services are updated. Progress is not estimated
// for paused experiment.
#ExperimentProgressing: #ExperimentConditionType & "Progressing"

// ExperimentRunning means that an experiment has reached the desired state and is running for the duration
// specified in the spec
#ExperimentRunning: #ExperimentConditionType & "Running"

// ExperimentReplicaFailure ReplicaFailure is added in a experiment when one of its pods
// fails to be created or deleted.
#ExperimentReplicaFailure: #ExperimentConditionType & "ReplicaFailure"

// ExperimentCondition describes the state of a experiment at a certain point.
#ExperimentCondition: {
	// Type of deployment condition.
	type: #ExperimentConditionType @go(Type) @protobuf(1,bytes,opt,casttype=ExperimentConditionType)

	// Phase of the condition, one of True, False, Unknown.
	status: corev1.#ConditionStatus @go(Status) @protobuf(2,bytes,opt,casttype=k8s.io/api/core/v1.ConditionStatus)

	// The last time this condition was updated.
	lastUpdateTime: metav1.#Time @go(LastUpdateTime) @protobuf(3,bytes,opt)

	// Last time the condition transitioned from one status to another.
	lastTransitionTime: metav1.#Time @go(LastTransitionTime) @protobuf(4,bytes,opt)

	// The reason for the condition's last transition.
	reason: string @go(Reason) @protobuf(5,bytes,opt)

	// A human readable message indicating details about the transition.
	message: string @go(Message) @protobuf(6,bytes,opt)
}

// ExperimentList is a list of Experiment resources
#ExperimentList: {
	metav1.#TypeMeta
	metadata: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)
	items: [...#Experiment] @go(Items,[]Experiment) @protobuf(2,bytes,rep)
}

#ExperimentAnalysisTemplateRef: {
	// Name is the name of the analysis
	name: string @go(Name) @protobuf(1,bytes,opt)

	// TemplateName reference of the AnalysisTemplate name used by the Experiment to create the run
	templateName: string @go(TemplateName) @protobuf(2,bytes,opt)

	// Whether to look for the templateName at cluster scope or namespace scope
	// +optional
	clusterScope?: bool @go(ClusterScope) @protobuf(3,varint,opt)

	// Args are the arguments that will be added to the AnalysisRuns
	// +optional
	// +patchMergeKey=name
	// +patchStrategy=merge
	args?: [...#Argument] @go(Args,[]Argument) @protobuf(4,bytes,rep)

	// RequiredForCompletion blocks the Experiment from completing until the analysis has completed
	requiredForCompletion?: bool @go(RequiredForCompletion) @protobuf(5,varint,opt)
}

#ExperimentAnalysisRunStatus: {
	// Name is the name of the analysis
	name: string @go(Name) @protobuf(1,bytes,opt)

	// AnalysisRun is the name of the AnalysisRun
	analysisRun: string @go(AnalysisRun) @protobuf(2,bytes,opt)

	// Phase is the status of the AnalysisRun
	phase: #AnalysisPhase @go(Phase) @protobuf(3,bytes,opt,casttype=AnalysisPhase)

	// Message is a message explaining the current status
	message?: string @go(Message) @protobuf(4,bytes,opt)
}
