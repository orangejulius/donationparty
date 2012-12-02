from django.http import HttpResponseRedirect, HttpResponse
from django.shortcuts import get_object_or_404, render_to_response
from django.template import RequestContext
from donationparty.models import Round
import json

def home(request):
    round = Round.objects.create(url=Round.generate_url())
    
    return HttpResponseRedirect(round.absolute_url())
    
def round_page(request, round_id):
    round = get_object_or_404(Round, url=round_id)

    if request.method.POST:
        return round_create(request, round_id)
    
    if round.closed:
        return render_to_response('round_closed.xhtml', {
            'round': round,
        }, context_instance=RequestContext(request))
    elif round.charity:
        return render_to_response('round_running.xhtml', {
            'round': round,
        }, context_instance=RequestContext(request))
    else:
        return render_to_response('round_create.xhtml', {
            'round': round,
        }, context_instance=RequestContext(request))

def round_create(request, round_id):
    round = get_object_or_404(Round, url=round_id)
    charity_name = request.POST['charity']
    invitees = request.POST['invitees']
    
    round.charity = charity_name
    round.invitees = invitees
    round.save()
    
    # XXX TODO: Parse invitees and send email
    return render_to_response('round_running.xhtml', {
        'round': round,
    }, context_instance=RequestContext(request))

    
def round_status(request, round_id):
    round = get_object_or_404(Round, url=round_id)
    people = round.donations.all()
    
    data = {
        'url': round.url,
        'charity': round.charity,
        'created': round.created,
        'closed': round.closed,
        'failed': round.failed,
        'people': [{
            'name': person.name,
            'created': person.created,
            'amount': round.closed and person.amount,
        } for person in people],
    }
    return HttpResponse(json.encode(data), mimetype='application/json')