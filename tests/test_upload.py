import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
import types
requests_stub = types.ModuleType("requests")
sys.modules.setdefault("requests", requests_stub)
from upload import construct_upload_endpoint, UPLOAD_ENDPOINT_TEMPLATE_NO_ACTION_NAME


def test_construct_upload_endpoint_with_action():
    url = construct_upload_endpoint('my_action')
    assert url.endswith('/my_action/bundle')


def test_construct_upload_endpoint_no_action():
    url = construct_upload_endpoint(None)
    assert url == UPLOAD_ENDPOINT_TEMPLATE_NO_ACTION_NAME
